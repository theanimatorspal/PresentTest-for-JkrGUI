require "Present.Present"

FancyAndroid = function(inFancyAndroidTable)
          return { FancyAndroid = inFancyAndroidTable }
end
-- TODO Fancy defer listen = false at last,
-- do this later in execution
gprocess.FancyAndroid = function(inPresentation, inValue, inFrameIndex, inElementName)
          Engine.net.Server() -- dont start the server but provide  the functions
          Engine.gate[1] = function()
                    Engine = mt:Get("Engine", StateId)
                    Engine:PrepareMultiThreadingAndNetworking()
                    local gate = Engine.gate
                    local net = Engine.net
                    Engine.net.Server()
                    gate.ip_addresses = net.Start()
                    gate.net = Engine.net
                    local listen = true
                    while listen and (not gate.application_has_ended) and (not gate.__fancy_android_device_connected) do
                              net.BroadCast(
                                        function()
                                                  Engine.net.SendToServer("Connection Established")
                                        end
                              )
                              Jkr.SleepForMiliSeconds(1000)
                              local msg = net.listenOnce()
                              if type(msg) == "string" and msg == "Connection Established" then
                                        print("HERE")
                                        listen = false
                                        gate.__fancy_android_device_connected = true
                                        net.BroadCast(function()
                                                  gwr = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
                                                  f = gwr.CreateFont("font.ttf", 14)
                                                  REMOTE_NEXT_BUTTON = gwr.CreateGeneralButton(vec3(0, 0, 20),
                                                            vec3(framed.x, framed.y / 2, 1),
                                                            function()
                                                                      Engine.net.SendToServer(function()
                                                                                gMoveForward()
                                                                      end)
                                                            end, false, f, "Next",
                                                            vec4(0, 0, 0, 1), vec4(1))
                                                  REMOTE_NEXT_BUTTON:Update(vec3(0, 0, 20),
                                                            vec3(framed.x, framed.y / 2, 1))


                                                  REMOVE_PREV_BUTTON = gwr.CreateGeneralButton(vec3(0, 0, 20),
                                                            vec3(framed.x, framed.y / 2, 1), function()
                                                                      Engine.net.SendToServer(function()
                                                                                gMoveBackward()
                                                                      end)
                                                            end, false, f, "Previous",
                                                            vec4(0, 0, 0, 1), vec4(1))

                                                  REMOVE_PREV_BUTTON:Update(vec3(0, framed.y / 2, 20),
                                                            vec3(framed.x, framed.y / 2, 1))
                                        end
                                        )
                              end
                    end
          end

          IterateEachFrame(inPresentation, function(inEachFrame, _)
                    gAddFrameKeyElement(inEachFrame, {
                              {
                                        "*FANDR*",
                                        handle = nil,
                                        value = inValue,
                                        name = "__fancy_android_listener"
                              }
                    })
          end)

          while not Engine.gate.ip_addresses do
          end

          local layout = {};
          for i = 1, #Engine.gate.ip_addresses do
                    layout[#layout + 1] = U({
                              t = Engine.gate.ip_addresses[i],
                              f = "Huge"
                    });
          end
          local vlayout = V():Add(layout, CR(layout))
          vlayout:Update(vec3(0, 0, gbaseDepth),
                    vec3(gFrameDimension.x, gFrameDimension.y, 1))
          for i = 1, #layout do
                    gprocess.FancyButton(inPresentation, FancyButton(layout[i]).FancyButton, inFrameIndex,
                              "__fancy_ip_address_" .. i)
          end
end


ExecuteFunctions["*FANDR*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          if not Engine.net.listenOnce then
                    Engine.net.Server()
          end
          if Engine.gate.__fancy_android_device_connected then
                    local Message = Engine.net.listenOnce()
                    if type(Message) == "function" then
                              Message()
                    end
          end
          if Engine.gate.__fancy_function then
                    Engine.gate.__fancy_function()
          end
end
