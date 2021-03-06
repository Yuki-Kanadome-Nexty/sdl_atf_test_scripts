---------------------------------------------------------------------------------------------------
-- Description: Check that SDL doesn't transfer OnVehicleData notification with <vd_param> parameter to App
-- if an app is not subscribed to this parameter
--
-- Preconditions:
-- 1) SDL and HMI are started
-- 2) SubscribeVehicleData, UnsubscribeVehicleData, OnVehicleData RPCs and
--  <vd_param> parameter are allowed by policies
-- 3) App is registered
-- 4) App is subscribed to <vd_param> parameter
--
-- In case:
-- 1) HMI sends valid OnVehicleData notification with <vd_param> parameter data to SDL
-- SDL does:
-- - a) transfer this notification to App
-- 2) App unsubscribes from <vd_param> parameter
-- 3) HMI sends valid OnVehicleData notification with <vd_param> parameter data to SDL
-- SDL does:
-- - a) not transfer this notification to App
-- Exception: Notification for unsubscribable VD parameter is not transfered
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local common = require('test_scripts/API/VehicleData/common')

--[[ Scenario ]]
common.Title("Preconditions")
common.Step("Clean environment and update preloaded_pt file", common.preconditions)
common.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
common.Step("Register App", common.registerApp)

common.Title("Test")
for param in common.spairs(common.getVDParams(true)) do
  common.Title("VD parameter: " .. param)
  common.Step("RPC " .. common.rpc.sub, common.processSubscriptionRPC, { common.rpc.sub, param })
  common.Step("RPC " .. common.rpc.on, common.sendOnVehicleData, { param, common.isExpected })
  common.Step("RPC " .. common.rpc.unsub, common.processSubscriptionRPC, { common.rpc.unsub, param })
  common.Step("RPC " .. common.rpc.on, common.sendOnVehicleData, { param, common.isNotExpected })
end
for param in common.spairs(common.getVDParams(false)) do
  common.Title("VD parameter: " .. param)
  common.Step("RPC " .. common.rpc.on, common.sendOnVehicleData, { param, common.isNotExpected })
end

common.Title("Postconditions")
common.Step("Stop SDL", common.postconditions)
