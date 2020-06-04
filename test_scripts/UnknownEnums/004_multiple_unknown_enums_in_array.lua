---------------------------------------------------------------------------------------------------
-- Description:
-- Mobile sends multiple unknown enum as part of an array of enums. The enum will be filtered out and
-- WARNINGS will be returned because the parameter was not mandatory.

-- Pre-conditions:
-- a. HMI and SDL are started

-- Steps:
-- appID sends a RegisterAppInterface with only unknown appHMIType enum.

-- Expected:
-- SDL Core filters out the unknown enum. The app registers successfully.
-- WARNINGS result is returned to mobile.
---------------------------------------------------------------------------------------------------

--[[ Required Shared libraries ]]
local runner = require('user_modules/script_runner')
local commonSmoke = require('test_scripts/Smoke/commonSmoke')

--[[ Test Configuration ]]
runner.testSettings.isSelfIncluded = false

--[[ Local Variables ]]
local appID = 1

local function RAIWithUnknownEnum()
    commonSmoke.createMobileSession(appID, nil, appID)
    commonSmoke.getMobileSession(appID):StartService(7)
    :Do(function()
        local requestParams = commonSmoke.app.getParams(appID)
        requestParams["appHMIType"] = {"UNKOWN_1", "UNKNOWN_2"}
        local CorIdRAI = commonSmoke.getMobileSession():SendRPC("RegisterAppInterface", requestParams)
        commonSmoke.getMobileSession():ExpectResponse(CorIdRAI, { 
            success = true, 
            resultCode = "WARNINGS", 
            info = "RPC.msg_params.appHMIType.0: Filtered invalid value - UNKOWN_1\nRPC.msg_params.appHMIType.1: Filtered invalid value - UNKNOWN_2"
        })
    end)
end

--[[ Scenario ]]
runner.Title("Preconditions")
runner.Step("Clean environment", commonSmoke.preconditions)
runner.Step("Start SDL, HMI, connect Mobile, start Session", commonSmoke.start)

runner.Title("Test")
runner.Step("Send Mandatory Unknown Enum", RAIWithUnknownEnum)

runner.Title("Postconditions")
runner.Step("Stop SDL", commonSmoke.postconditions)
