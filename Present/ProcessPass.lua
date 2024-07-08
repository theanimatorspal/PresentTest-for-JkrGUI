require("Present.require")
require("Present.inspect")
local inspect = require("Present.inspect")

local index = 0
local Unique = function(inElementName) -- Generate Unique Name
          if type(inElementName) == "number" then
                    index = index + 1
                    return index
          elseif type(inElementName) == "string" then
                    return inElementName
          end
end

local AddFrameKey = function(inKey, inFrameIndex)
          gFrameKeys[inFrameIndex][#gFrameKeys[inFrameIndex] + 1] = inKey
          -- print("gFrameKeys = ", inspect(gFrameKeys))
end


ProcessFunctions = {
          TitlePage = function(inPresentation, inValue, inFrameIndex, inElementName)
                    local title = inPresentation.Title
                    local date = inPresentation.Date
                    local author = inPresentation.Author
                    -- TODO title page
          end,
          Enumerate = function(inPresentation, inValue, inFrameIndex, inElementName)
          end,
          Text = function(inPresentation, inValue, inFrameIndex, inElementName)
                    local ElementName = Unique(inElementName)
                    if not gscreenElements[ElementName] then
                              gscreenElements[ElementName] =
                                  gwid.CreateTextLabel(
                                            vec3(math.huge),
                                            vec3(math.huge),
                                            gFontMap[inValue.f],
                                            inValue.t,
                                            inValue.c
                                  )
                    end
                    inValue.d = gFontMap[inValue.f]:GetTextDimension(inValue.t)
                    AddFrameKey({
                              FrameIndex = inFrameIndex,
                              Elements = { {
                                        "TEXT",
                                        handle = gscreenElements[ElementName],
                                        value = inValue,
                                        name = ElementName
                              } }
                    }, inFrameIndex)
          end
}

ProcessLiterals = function(inName, inValue)
          gliterals[inName] = inValue
end
