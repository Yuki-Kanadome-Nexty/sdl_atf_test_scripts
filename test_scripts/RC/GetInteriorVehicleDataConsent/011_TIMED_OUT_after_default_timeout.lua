---------------------------------------------------------------------------------------------------
-- Requirement summary:
-- [SDL_RC] Resource allocation based on access mode
--
-- Sequence:
-- 1) 2 REMOTE_CONTROL Apps are registered (App_1, App_2)
-- 2) Access mode: ASK_DRIVER
-- 3) App_1 takes control for <module>
-- 4) App_2 is activated (FULL)
-- 5) App_2->SDL: <RC_control_RPC> for <module>
-- 6) SDL->HMI: GetInteriorVehicleDataConsent (App_2)
-- 7) HMI doesn't respond for GetInteriorVehicleDataConsent (App_2) during default period (10s)
-- 8) HMI->SDL: TIMED_OUT: GetInteriorVehicleDataConsent (App_2) after default period (10s)
-- 9) SDL->App_2: GENERIC_ERROR: SetInteriorVehicleData (success:false)
-- 10) SDL doesn't transfer <RC_control_RPC> request for <module> to HMI
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local runner = require('user_modules/script_runner')
local commonRC = require('test_scripts/RC/commonRC')
local commonTestCases = require("user_modules/shared_testcases/commonTestCases")

--[[ Local Variables ]]
local pModuleType = "CLIMATE"
local pRPC1 = "SetInteriorVehicleData"

--[[ Local Functions ]]
local function ptu_update_func(tbl)
  tbl.policy_table.app_policies[config.application2.registerAppInterfaceParams.appID] = commonRC.getRCAppConfig()
end

local function rpcHMIRespondAfterDefaultTimeout(self)
  local cid1 = self.mobileSession2:SendRPC(commonRC.getAppEventName(pRPC1), commonRC.getAppRequestParams(pRPC1, pModuleType))
  local consentRPC = "GetInteriorVehicleDataConsent"
  EXPECT_HMICALL(commonRC.getHMIEventName(consentRPC), commonRC.getHMIRequestParams(consentRPC, pModuleType, 2))
  :Do(function(_, data)
      local function hmiRespond()
        self.hmiConnection:SendError(data.id, data.method, "TIMED_OUT", "info")
        EXPECT_HMICALL(commonRC.getHMIEventName(pRPC1)):Times(0)
      end
      RUN_AFTER(hmiRespond, 11000)
    end)

  self.mobileSession2:ExpectResponse(cid1, { success = false, resultCode = "GENERIC_ERROR" })
  commonTestCases:DelayedExp(12000)
end

--[[ Scenario ]]
runner.Title("Preconditions")
runner.Step("Clean environment", commonRC.preconditions)
runner.Step("Start SDL, HMI, connect Mobile, start Session", commonRC.start)
runner.Step("RAI1, PTU", commonRC.rai_ptu, { ptu_update_func })
runner.Step("RAI2", commonRC.rai_n, { 2 })
runner.Step("Activate App1", commonRC.activate_app)

runner.Title("Test")
runner.Step("Set RA mode: ASK_DRIVER", commonRC.defineRAMode, { true, "ASK_DRIVER" })

runner.Step("App1 SetInteriorVehicleData", commonRC.rpcAllowed, { pModuleType, 1, "SetInteriorVehicleData" })

runner.Step("Activate App2", commonRC.activate_app, { 2 })
runner.Step("App2 SetInteriorVehicleData, HMI respond after default timeout", rpcHMIRespondAfterDefaultTimeout)

runner.Title("Postconditions")
runner.Step("Stop SDL", commonRC.postconditions)