---------------------------------------------------------------------------------------------------
-- Proposal: https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0173-Read-Generic-Network-Signal-data.md
--
-- Description: SDL does no apply any changes for VDI after PTU without version in custom_vehicle_data_mapping_url

-- Precondition:
-- 1. Preloaded file contains VehicleDataItems for all RPC spec VD
-- 2. App is registered and activated
-- 3. PTU is started
-- 4. The update received from cloud without version in custom_vehicle_data_mapping_url

-- Sequence:
-- 1. Update is considered as invalid and PTU status is still UPDATE_NEEDED
-- 2. Mobile app requests RPC with RPC spec data
--   a. SDL processes the request successfully
-- 2. Mobile app requests RPC with custom data from PTU
--   a. SDL rejects requests with INVALID_DATA resultCode
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local runner = require('user_modules/script_runner')
local common = require('test_scripts/API/VehicleData/GenericNetworkSignalData/commonGenericNetSignalData')

--[[ Test Configuration ]]
runner.testSettings.isSelfIncluded = false

--[[ Local Variables ]]
common.writeCustomDataToGeneralArray(common.customDataTypeSample)
common.setDefaultValuesForCustomData()

local appSessionId = 1

local customData, rpcSpecData = common.getCustomAndRpcSpecDataNames()

--[[ Local Functions ]]
local function ptuFunc(pTbl)
  common.ptuFuncWithCustomData(pTbl)
  pTbl.policy_table.module_config.endpoint_properties.custom_vehicle_data_mapping_url = common.EMPTY_ARRAY
end

-- [[ Scenario ]]
runner.Title("Preconditions")
runner.Step("Clean environment", common.preconditions)
runner.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
runner.Step("App registration", common.registerApp)
runner.Step("App activation", common.activateApp)
runner.Step("PTU with VehicleDataItems", common.policyTableUpdate, { ptuFunc, common.expUpdateNeeded })

runner.Title("Test")
for _, vehicleDataItem in pairs(rpcSpecData) do
  if vehicleDataItem == "vin" then
    runner.Step("GetVehicleData " .. vehicleDataItem, common.GetVD,
      { appSessionId, vehicleDataItem })
  else
    runner.Step("SubscribeVehicleData " .. vehicleDataItem, common.VDsubscription,
      { appSessionId, vehicleDataItem, "SubscribeVehicleData" })
    runner.Step("OnVehicleData " .. vehicleDataItem, common.onVD,
      { appSessionId, vehicleDataItem })
    runner.Step("GetVehicleData " .. vehicleDataItem, common.GetVD,
      { appSessionId, vehicleDataItem })
    runner.Step("UnsubscribeVehicleData " .. vehicleDataItem, common.VDsubscription,
      { appSessionId, vehicleDataItem, "UnsubscribeVehicleData" })
    runner.Step("OnVehicleData " .. vehicleDataItem, common.onVD,
      { appSessionId, vehicleDataItem, common.VD.NOT_EXPECTED })
  end
end
for _, vehicleDataItem in pairs(customData) do
  runner.Step("SubscribeVehicleData INVALID_DATA " .. vehicleDataItem, common.errorRPCprocessing,
    { appSessionId, vehicleDataItem, "SubscribeVehicleData", "INVALID_DATA" })
  runner.Step("OnVehicleData " .. vehicleDataItem, common.onVD,
    { appSessionId, vehicleDataItem, common.VD.NOT_EXPECTED })
  runner.Step("GetVehicleData INVALID_DATA " .. vehicleDataItem, common.errorRPCprocessing,
    { appSessionId, vehicleDataItem, "GetVehicleData", "INVALID_DATA" })
  runner.Step("UnsubscribeVehicleData INVALID_DATA " .. vehicleDataItem, common.errorRPCprocessing,
    { appSessionId, vehicleDataItem, "UnsubscribeVehicleData", "INVALID_DATA" })
end

runner.Title("Postconditions")
runner.Step("Stop SDL", common.postconditions)
