---------------------------------------------------------------------------------------------------
-- Description: Check that SDL rejects GetVehicleData request with resultCode "DISALLOWED"
-- if <vd_param> parameter is not allowed by policy
--
-- Preconditions:
-- 1) SDL and HMI are started
-- 2) <vd_param> parameter is not allowed by policies
-- 3) App is registered
--
-- In case:
-- 1) App sends valid GetVehicleData(<vd_param>=true) request to SDL
-- SDL does:
-- - a) send GetVehicleData response with (success = false, resultCode = "DISALLOWED") to App
-- - b) not transfer this request to HMI
---------------------------------------------------------------------------------------------------
--[[ Required Shared libraries ]]
local common = require('test_scripts/API/VehicleData/common')

--[[ Local Variables ]]
local result = "DISALLOWED"

--[[ Local Functions ]]
local function getVDGroup(pDisallowedParam)
  local params = {}
  for param in pairs(common.getVDParams()) do
    if param ~= pDisallowedParam then table.insert(params, param) end
  end
  return {
    rpcs = {
      [common.rpc.get] = {
        hmi_levels = { "NONE", "BACKGROUND", "LIMITED", "FULL" },
        parameters = params
      }
    }
  }
end

--[[ Scenario ]]
for param in common.spairs(common.getVDParams()) do
  common.Title("VD parameter: " .. param)
  common.Title("Preconditions")
  common.Step("Clean environment and update preloaded_pt file", common.preconditions, { getVDGroup(param) })
  common.Step("Start SDL, HMI, connect Mobile, start Session", common.start)
  common.Step("Register App", common.registerApp)

  common.Title("Test")
  common.Step("RPC " .. common.rpc.get .. " DISALLOWED", common.processRPCFailure,
    { common.rpc.get, param, result })

  common.Title("Postconditions")
  common.Step("Stop SDL", common.postconditions)
end
