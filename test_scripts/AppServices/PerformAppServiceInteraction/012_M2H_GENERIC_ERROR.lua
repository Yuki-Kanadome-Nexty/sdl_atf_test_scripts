---------------------------------------------------------------------------------------------------
--  Precondition: 
--  1) Application with <appID> is registered on SDL.
--  2) Specific permissions are assigned for <appID> with PerformAppServiceInteraction
--  3) HMI has published a MEDIA service
--
--  Steps:
--  1) Application sends a PerformAppServiceInteraction RPC request with HMI's serviceID
--
--  Expected:
--  1) SDL forwards the PerformAppServiceInteraction request to the HMI as AppService.PerformAppServiceInteraction
--  2) HMI does not respond to SDL
--  3) SDL sends a GENERIC_ERROR response to the Application when the request times out
---------------------------------------------------------------------------------------------------

--[[ Required Shared libraries ]]
local runner = require('user_modules/script_runner')
local common = require('test_scripts/AppServices/commonAppServices')

--[[ Test Configuration ]]
runner.testSettings.isSelfIncluded = false

--[[ Local Variables ]]
local manifest = {
  serviceName = "HMI_MEDIA_SERVICE",
  serviceType = "MEDIA",
  allowAppConsumers = true,
  rpcSpecVersion = config.application1.registerAppInterfaceParams.syncMsgVersion,
  mediaServiceManifest = {}
}

local rpc = {
  name = "PerformAppServiceInteraction",
  hmiName = "AppService.PerformAppServiceInteraction",
  params = {
    originApp = config.application1.registerAppInterfaceParams.fullAppID,
    serviceUri = "hmi:sample.service.uri"
  }
}

local expectedResponse = {
  success = false,
  resultCode = "GENERIC_ERROR"
}

local function PTUfunc(tbl)
  tbl.policy_table.app_policies[common.getConfigAppParams(1).fullAppID] = common.getAppServiceConsumerConfig(1);
end

--[[ Local Functions ]]
local function processRPCSuccess(self)
  local mobileSession = common.getMobileSession()
  local service_id = common.getAppServiceID(0)
  local requestParams = rpc.params
  requestParams.serviceID = service_id
  local cid = mobileSession:SendRPC(rpc.name, requestParams)
  -- Do not respond to request
  EXPECT_HMICALL(rpc.hmiName, requestParams)

  mobileSession:ExpectResponse(cid, expectedResponse)
  :Timeout(runner.testSettings.defaultTimeout + common.getRpcPassThroughTimeoutFromINI() + 1000)
end

--[[ Scenario ]]
runner.Title("Preconditions")
runner.Step("Clean environment", common.preconditions)
runner.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
runner.Step("RAI", common.registerApp)
runner.Step("PTU", common.policyTableUpdate, { PTUfunc })
runner.Step("Activate App", common.activateApp)
runner.Step("Publish App Service", common.publishEmbeddedAppService, { manifest })

runner.Title("Test")
runner.Step("RPC " .. rpc.name .. "_resultCode_GENERIC_ERROR", processRPCSuccess)

runner.Title("Postconditions")
runner.Step("Stop SDL", common.postconditions)
