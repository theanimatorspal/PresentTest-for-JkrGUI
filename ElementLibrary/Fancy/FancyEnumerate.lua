require "ElementLibrary.Fancy.FancyRequire"

FancyEnumerate = function(inFancyEnumerateTable)
          local t = {
                    t = "__Enumeration",
                    items = {
                    },
                    indicate = -1,
                    view = -1,
                    hide = {},
                    rp = vec2(-0.9, -0.3),
                    rd = vec2(0.6, 0.3)
          }
          if not inFancyEnumerateTable.rp and not inFancyEnumerateTable.rd then
                    local outT = Default(inFancyEnumerateTable, t)
                    outT.rd.y = 0.1 * #outT.items
                    outT.rp.y = -0.1 * #outT.items
                    return { FancyEnumerate = outT }
          else
                    return { FancyEnumerate = Default(inFancyEnumerateTable, t) }
          end
end

local gEnums = {}
gprocess.FancyEnumerate = function(inPresentation, inValue, inFrameIndex, inElementName)
          local Elementname = Unique(inElementName)
          local title = U()
          title.t = inValue.t

          local items = {}
          local item_bullets = {}

          if gEnums[Elementname] then
                    inValue.items = Copy(gEnums[Elementname].items)
          else
                    gEnums[Elementname] = Copy(inValue)
          end

          -- This is the text
          for i = 1, #inValue.items, 1 do
                    local it = U()
                    local itb = U()
                    it.t = Copy(inValue.items[i])
                    itb.t = "" .. i
                    if inValue.indicate > 0 then
                              it.bc = white_color
                              itb.bc = white_color
                              it.o = "LEFT"
                    else
                              it.bc = transparent_color
                              itb.bc = transparent_color
                              it.o = "LEFT"
                    end

                    if table.contains(inValue.hide, i) then
                              itb.bc = vec4(0)
                              itb.c = vec4(0)
                              it.bc = vec4(0)
                              it.c = vec4(0)
                    end

                    items[#items + 1] = it
                    item_bullets[#item_bullets + 1] = itb
          end
          H():AddComponents(
                    {
                              V():AddComponents(item_bullets, CR(item_bullets)),
                              V():AddComponents(items, CR(items)),
                    }, { 0.1, 0.9 }
          ):Update(rel_to_abs_p(inValue.rp), rel_to_abs_d(inValue.rd))

          if inValue.view ~= -1 then
                    for i = 1, #items, 1 do
                              if i ~= inValue.view then
                                        items[i].bc = vec4(0)
                                        item_bullets[i].bc = vec4(0)
                                        items[i].c = vec4(0)
                                        item_bullets[i].c = vec4(0)
                              end
                    end
                    V():AddComponents(
                              {
                                        U(),
                                        H():AddComponents({
                                                  item_bullets[inValue.view],
                                                  items[inValue.view],
                                        }, { 0.1, 0.8 }),
                                        U()
                              }, { 0.1, 0.1, 0.8 }
                    ):Update(vec3(0, 0, gbaseDepth), vec3(gFrameDimension.x, gFrameDimension.y, 1))
          end

          -- print("items:", ginspect(items))
          -- print("item_bullets:", ginspect(item_bullets))


          for i, value in ipairs(items) do
                    value._push_constant = StrechedPC
                    gprocess.FancyButton(inPresentation, FancyButton(value).FancyButton, inFrameIndex,
                              "__fancy__enumeration" .. "__items__" .. inElementName .. i)
          end

          for i, value in ipairs(item_bullets) do
                    gprocess.FancyButton(inPresentation, FancyButton(value).FancyButton, inFrameIndex,
                              "__fancy_enumeration" .. "__bullets__" .. inElementName .. i)
          end
end
