require "Present.Present"

FancyPicture = function(inFancyPictureTable)
          local t = {
                    pic = -1,
                    p = "CENTER_CENTER",
                    d = vec3(100, 100, 1),
                    ar = 1,       -- aspect ratio
                    bh = "BY_HEIGHT",
                    c = vec4(1),  -- Image color
                    bc = vec4(1), -- Image color
          }
          return { FancyPicture = Default(inFancyPictureTable, t) }
end


gprocess.FancyPicture = function(inPresentation, inValue, inFrameIndex, inElementName)
          local ElementName = Unique(inElementName)
          local PrevD = vec3(inValue.d.x, inValue.d.y, inValue.d.z)
          if inValue.ar and inValue.bh then
                    if inValue.bh == "BY_HEIGHT" then
                              inValue.d.x = inValue.ar * inValue.d.y
                    elseif inValue.bh == "BY_WIDTH" then
                              inValue.d.y = inValue.ar * inValue.d.x
                    end
          end
          if PrevD.x > inValue.d.x then
                    inValue.p.x = inValue.p.x + (PrevD.x - inValue.d.x) / 2
          end
          if PrevD.y > inValue.d.y then
                    inValue.p.y = inValue.p.y + (PrevD.y - inValue.d.y) / 2
          end
          if not gscreenElements[ElementName] then
                    if inValue.pic ~= -1 then
                              gscreenElements[ElementName] = gwid.CreatePressButton(
                                        vec3(math.huge), vec3(inValue.d), inValue.onclick, false, nil,
                                        nil, inValue.c, inValue.bc, nil, inValue.pic
                              )
                    end
          end
          AddFrameKeyElement(inFrameIndex, {
                    {
                              "*FP*",
                              handle = gscreenElements[ElementName],
                              value = inValue,
                              name = ElementName
                    }
          })
end

ExecuteFunctions["*FP*"] = function(inPresentation, inElement, inFrameIndex, t, inDirection)
          local PreviousElement, inElement = GetPreviousFrameKeyElementD(inPresentation, inElement,
                    inFrameIndex, inDirection)
          local new = inElement.value
          if PreviousElement then
                    local prev = PreviousElement.value
                    local interp = glerp_3f(ComputePositionByName(prev.p, prev.d), ComputePositionByName(new.p, new.d), t)
                    local interd = glerp_3f(prev.d, new.d, t)
                    local interc = glerp_4f(prev.c, new.c, t)
                    local interbc = glerp_4f(prev.bc, new.bc, t)
                    inElement.handle:Update(interp, interd, nil, nil, interc, interbc)
          else
                    inElement.handle:Update(ComputePositionByName(new.p, new.d), new.d, nil, nil, new.c,
                              new.bc, new.o)
          end
end
