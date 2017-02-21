local commonSteps = require("user_modules/shared_testcases/commonSteps")
commonSteps:CheckSDLPath()
commonSteps:DeleteLogsFileAndPolicyTable()

local commonPreconditions = require("user_modules/shared_testcases/commonPreconditions")
commonPreconditions:BackupFile("sdl_preloaded_pt.json")
commonPreconditions:ReplaceFile("sdl_preloaded_pt.json", "./files/jsons/RC/rc_sdl_preloaded_pt.json")

local revsdl = require("user_modules/revsdl")

revsdl.AddUnknownFunctionIDs()
revsdl.SubscribeToRcInterface()
config.ValidateSchema = false
config.application1.registerAppInterfaceParams.appHMIType = { "REMOTE_CONTROL" }
config.application1.registerAppInterfaceParams.appID = "8675311"

Test = require('connecttest')
require('cardinalities')

--List permission of "OnPermissionsChange" for PrimaryDevice and NonPrimaryDevice
--groups_PrimaryRC Group
local arrayGroups_PrimaryRC = revsdl.arrayGroups_PrimaryRC()

local device1mac = "12ca17b49af2289436f303e0166030a21e525d266e209267433801a8fd4071a0"

--======================================Requirement========================================--
---------------------------------------------------------------------------------------------
--------------Requirement: SetInteriorVehicleData: conditions to return----------------------
----------------------------------READ_ONLY resultCode---------------------------------------
---------------------------------------------------------------------------------------------
--=========================================================================================--

--=================================================BEGIN TEST CASES 3==========================================================--
	--Begin Test suit CommonRequestCheck.3 for Req.#3

	--Description: In case: application sends valid SetInteriorVehicleData with read-only parameters and one or more settable parameters in "radioControlData" struct, for muduleType: RADIO, RSDL must
						--cut the read-only parameters off and process this RPC as assigned (that is, check policies, send to HMI, and etc. per existing requirements)


	--Begin Test case CommonRequestCheck.3.1
	--Description: 	--PASSENGER's Device
					--RSDL cut the read-only parameters off and process this RPC as assigned.

		--Requirement/Diagrams id in jira:
				--Requirement
				--https://adc.luxoft.com/jira/secure/attachment/127928/127928_model_SetInteriorVehicleData-READ_ONLY.png

		--Verification criteria:
				--For PASSENGER'S Device

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.1.1
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and frequencyInteger parameter
				function Test:PASSENGER_SETTABLE_frequencyInteger()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								frequencyInteger = 105,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								frequencyInteger = 105
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															frequencyInteger = 105
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.1.1

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.1.2
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and frequencyFraction parameter
				function Test:PASSENGER_SETTABLE_frequencyFraction()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								frequencyFraction = 3,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								frequencyFraction = 3
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															frequencyFraction = 3
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.1.2

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.1.3
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and band parameter
				function Test:PASSENGER_SETTABLE_band()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								band = "AM",
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								band = "AM"
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															band = "AM"
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.1.3

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.1.4
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and hdChannel parameter
				function Test:PASSENGER_SETTABLE_hdChannel()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								hdChannel = 1,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								hdChannel = 1
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															hdChannel = 1
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.1.4

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.1.5
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and all parameters
				function Test:PASSENGER_SETTABLE_AllParams()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								frequencyInteger = 105,
								frequencyFraction = 3,
								band = "AM",
								hdChannel = 1,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								frequencyInteger = 105,
								frequencyFraction = 3,
								band = "AM",
								hdChannel = 1
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															frequencyInteger = 105,
															frequencyFraction = 3,
															band = "AM",
															hdChannel = 1
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.1.5

		-----------------------------------------------------------------------------------------
	--End Test case CommonRequestCheck.3.1


	--Begin Test case CommonRequestCheck.3.2
	--Description: 	--DRIVER's Device
					--RSDL cut the read-only parameters off and process this RPC as assigned.

		--Requirement/Diagrams id in jira:
				--Requirement
				--https://adc.luxoft.com/jira/secure/attachment/127928/127928_model_SetInteriorVehicleData-READ_ONLY.png

		--Verification criteria:
				--For DRIVER'S Device

			--Begin Test case CommonRequestCheck.3.2.0
			--Description: Sending SetInteriorVehicleData request with just read-only parameters
				function Test:SetPASSENGERToDRIVER()

					--hmi side: send request RC.OnDeviceRankChanged
					self.hmiConnection:SendNotification("RC.OnDeviceRankChanged",
															{deviceRank = "DRIVER", device = {name = "127.0.0.1", id = device1mac, isSDLAllowed = true}})

					--mobile side: Expect OnPermissionsChange notification for Driver's device
					self.mobileSession:ExpectNotification("OnPermissionsChange", arrayGroups_PrimaryRC )

					--mobile side: OnHMIStatus notifications with deviceRank = "DRIVER"
					self.mobileSession:ExpectNotification("OnHMIStatus",{ systemContext = "MAIN", audioStreamingState = "NOT_AUDIBLE", deviceRank = "DRIVER" })

				end
			--End Test case CommonRequestCheck.3.2.0

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.2.1
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and frequencyInteger parameter
				function Test:DRIVER_SETTABLE_frequencyInteger()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								frequencyInteger = 105,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								frequencyInteger = 105
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															frequencyInteger = 105
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.2.1

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.2.2
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and frequencyFraction parameter
				function Test:DRIVER_SETTABLE_frequencyFraction()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								frequencyFraction = 3,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								frequencyFraction = 3
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															frequencyFraction = 3
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.2.2

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.2.3
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and band parameter
				function Test:DRIVER_SETTABLE_band()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								band = "AM",
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								band = "AM"
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															band = "AM"
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.2.3

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.2.4
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and hdChannel parameter
				function Test:DRIVER_SETTABLE_hdChannel()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								hdChannel = 1,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								hdChannel = 1
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															hdChannel = 1
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.2.4

		-----------------------------------------------------------------------------------------

			--Begin Test case CommonRequestCheck.3.2.5
			--Description: Sending SetInteriorVehicleData request with and read-only parameters and all parameters
				function Test:DRIVER_SETTABLE_AllParams()
					--mobile side: sending SetInteriorVehicleData request with just read-only parameters and settable params in "radioControlData" struct, for muduleType: RADIO
					local cid = self.mobileSession:SendRPC("SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								radioEnable = true,--
								frequencyInteger = 105,
								frequencyFraction = 3,
								band = "AM",
								hdChannel = 1,
								state = "ACQUIRED",--
								availableHDs = 1,--
								signalStrength = 50,--
								rdsData =--
								{
									PS = "12345678",
									RT = "",
									CT = "123456789012345678901234",
									PI = "",
									PTY = 0,
									TP = true,
									TA = false,
									REG = ""
								},
								signalChangeThreshold = 10--
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					})

				--hmi side: expect RC.SetInteriorVehicleData request
				EXPECT_HMICALL("RC.SetInteriorVehicleData",
					{
						moduleData =
						{
							radioControlData =
							{
								frequencyInteger = 105,
								frequencyFraction = 3,
								band = "AM",
								hdChannel = 1
							},
							moduleType = "RADIO",
							moduleZone =
							{
								colspan = 2,
								row = 0,
								rowspan = 2,
								col = 0,
								levelspan = 1,
								level = 0
							}
						}
					}
				)
				:ValidIf (function(_,data)
					--RSDL must cut the read-only parameters off and process this RPC as assigned
					if data.params.moduleData.radioControlData.radioEnable or data.params.moduleData.radioControlData.state or data.params.moduleData.radioControlData.availableHDs or data.params.moduleData.radioControlData.signalStrength or data.params.moduleData.radioControlData.rdsData or data.params.moduleData.radioControlData.signalChangeThreshold then
						print(" --SDL sends fake parameter to HMI ")
						for key,value in pairs(data.params.moduleData.radioControlData) do print(key,value) end
						return false
					else
						return true
					end
				end)
				:Do(function(_,data)
					--hmi side: sending RC.SetInteriorVehicleData response
					self.hmiConnection:SendResponse(data.id, data.method, "SUCCESS", {
													moduleData =
													{
														radioControlData =
														{
															frequencyInteger = 105,
															frequencyFraction = 3,
															band = "AM",
															hdChannel = 1
														},
														moduleType = "RADIO",
														moduleZone =
														{
															colspan = 2,
															row = 0,
															rowspan = 2,
															col = 0,
															levelspan = 1,
															level = 0
														}
													}
					})
				end)

				--mobile side: expect SUCCESS response
				EXPECT_RESPONSE(cid, { success = true, resultCode = "SUCCESS"})

				end
			--End Test case CommonRequestCheck.3.2.5

		-----------------------------------------------------------------------------------------
	--End Test case CommonRequestCheck.3.2

--=================================================END TEST CASES 3==========================================================--

function Test.PostconditionsRestoreFile()
  commonPreconditions:RestoreFile("sdl_preloaded_pt.json")
end