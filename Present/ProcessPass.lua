require("Present.require")

local index = 0
gUnique = function(inElementName) -- Generate Unique Name
    if type(inElementName) == "number" then
        index = index + 1
        return index
    elseif type(inElementName) == "string" then
        return inElementName
    end
end

local AddFrameKey = function(inKey, inFrameIndex)
    gFrameKeys[inFrameIndex][#gFrameKeys[inFrameIndex] + 1] = inKey
end

gAddFrameKeyElement = function(inFrameIndex, inElements)
    AddFrameKey({
        FrameIndex = inFrameIndex,
        Elements = inElements,
    }, inFrameIndex)
end

local AddFrameKeyCompute = function(inKey, inFrameIndex)
    gFrameKeysCompute[inFrameIndex][#gFrameKeysCompute[inFrameIndex] + 1] = inKey
end

gAddFrameKeyElementCompute = function(inFrameIndex, inElements)
    AddFrameKeyCompute({
        FrameIndex = inFrameIndex,
        Elements = inElements,
    }, inFrameIndex)
end

gprocess = {
    TitlePage = function(inPresentation, inValue, inFrameIndex, inElementName)
        local title = inPresentation.Title
        local date = inPresentation.Date
        local author = inPresentation.Author
        -- TODO title page
    end,
    Text = function(inPresentation, inValue, inFrameIndex, inElementName)
        local ElementName = gUnique(inElementName)
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
    end,
    CImage = function(inPresentation, inValue, inFrameIndex, inElementName)
        local ElementName = gUnique(inElementName)
        if not gscreenElements[ElementName] then
            local image = {
                computeImage = gwid.CreateComputeImage(vec3(math.huge), vec3(inValue.d.x, inValue.d.y, 1)),
                sampledImage = gwid.CreateSampledImage(vec3(math.huge), vec3(inValue.d.x, inValue.d.y, 1))
            }
            gscreenElements[ElementName] = image
            image.computeImage.RegisterPainter(gscreenElements[inValue.shader])
        end
        AddFrameKey({
            FrameIndex = inFrameIndex,
            Elements = {
                {
                    "CIMAGE",
                    handle = gscreenElements[ElementName],
                    value = inValue,
                    name = ElementName
                }
            }
        }, inFrameIndex)
    end,
    Button = function(inPresentation, inValue, inFrameIndex, inElementName)
        local ElementName = gUnique(inElementName)
        if not gscreenElements[ElementName] then
            local Button = gwid.CreateButton(ComputePositionByName(inValue.p, inValue.d),
                vec3(inValue.d.x, inValue.d.y, 1),
                inValue.onclick)
            gscreenElements[ElementName] = Button
        end
        AddFrameKey({
            FrameIndex = inFrameIndex,
            Elements = {
                {
                    "BUTTON",
                    handle = gscreenElements[ElementName],
                    value = inValue,
                    name = ElementName
                }
            }
        }, inFrameIndex)
    end,
    ButtonText = function(inPresentation, inValue, inFrameIndex, inElementName)
        gprocess.Button(inPresentation, inValue, inFrameIndex, inElementName .. "button")
        gprocess.Text(inPresentation, inValue, inFrameIndex, inElementName .. "text")
    end,
    Shader = function(inPresentation, inValue, inFrameIndex, inElementName)
        local ElementName = gUnique(inElementName)
        if not gscreenElements[ElementName] then
            local painter = Jkr.CreateCustomImagePainter(
                ElementName .. ".glsl", inValue.cs
            )
            painter:Store(Engine.i, gwindow)
            gscreenElements[ElementName] = painter
        end
    end,
    GLTFView = function(inPresentation, inValue, inFrameIndex, inElementName)
        local ElementName = gUnique(inElementName)
        if not gscreenElements[ElementName] then
            -- make all the required uniforms
            -- make all the required simple3d
            -- get and upload the GLTF model to shit
            -- Make the Object3D and Upload to gobjects3d
        end
    end,
}
