require("Present.require")
require("Present.ProcessPass")
require("Present.ExecutePass")
require("Present.Elements")
---@diagnostic disable-next-line: lowercase-global
inspect = require("Present.inspect")
--[============================================================[
          PRESENTATION  FUNCTION
]============================================================]
PresentationEventFunction = function(inJumpToFrame,
                                     inDirection,
                                     shouldRun,
                                     int,
                                     inanimate)
    return inJumpToFrame,
        inDirection,
        shouldRun,
        int,
        inanimate
end

Presentation = function(inPresentation)
    local Log = function(inContent)
        -- print(string.format("[JkrGUI Present: ] %s", inContent))
    end
    local shouldRun = true
    local Validation = true

    -- If already initialized, don't again
    if not Engine.i then
        Engine:Load(Validation)
    end

    if not gwindow then
        gwindow = Jkr.CreateWindow(Engine.i, "Hello", vec2(900, 480), 3, gFrameDimension)
        gWindowDimension = gwindow:GetWindowDimension()
        gwid = Jkr.CreateWidgetRenderer(Engine.i, gwindow, Engine.e)
    end

    gwindow:Show()

    if inPresentation.Config then
        local conf = inPresentation.Config
        gFontMap.Tiny = gwid.CreateFont(conf.Font.Tiny[1], conf.Font.Tiny[2])
        gFontMap.Small = gwid.CreateFont(conf.Font.Small[1], conf.Font.Small[2])
        gFontMap.Normal = gwid.CreateFont(conf.Font.Normal[1], conf.Font.Normal[2])
        gFontMap.large = gwid.CreateFont(conf.Font.large[1], conf.Font.large[2])
        gFontMap.Large = gwid.CreateFont(conf.Font.Large[1], conf.Font.Large[2])
        gFontMap.huge = gwid.CreateFont(conf.Font.huge[1], conf.Font.huge[2])
        gFontMap.Huge = gwid.CreateFont(conf.Font.Huge[1], conf.Font.Huge[2])
        gFontMap.gigantic = gwid.CreateFont(conf.Font.gigantic[1], conf.Font.gigantic[2])
        gFontMap.Gigantic = gwid.CreateFont(conf.Font.Gigantic[1], conf.Font.Gigantic[2])
    else
        Log("Error: No Config provided.")
    end

    if shouldRun then
        --[[
                    Presentation {
                              {Frame = table}
                    }
                    ]]

        local FrameIndex = 1
        for _, elements in ipairs(inPresentation) do
            for __, value in pairs(elements) do
                if (__ == "Frame") then
                    gFrameKeys[FrameIndex] = {}
                    local frameElements = value
                    --[[==================================================]]
                    for felementName, felement in pairs(frameElements) do
                        if type(felement) == "table" then
                            for processFunctionIndex, ElementValue in pairs(felement) do
                                ProcessFunctions[processFunctionIndex](
                                    inPresentation, ElementValue,
                                    FrameIndex, felementName)
                            end
                        else
                            ProcessLiterals(felementName, felement)
                        end
                    end
                    --[[==================================================]]
                    FrameIndex = FrameIndex + 1
                end
            end
        end
        gFrameCount = FrameIndex

        local oldTime = 0.0
        local frameCount = 0
        local e = Engine.e
        local w = gwindow
        local mt = Engine.mt

        WindowClearColor = vec4(0)



        --[==================================================================]
        --
        --
        -- Event and Updates
        --
        --
        --[==================================================================]
        local currentFrame = 1
        local t = 0
        local hasNextFrame = false

        local currentTime = w:GetWindowCurrentTime()
        local stepTime = 0.01
        local residualTime = 0
        local direction = 1
        local animate = true

        local Event = function()
            if (e:IsKeyPressed(Keyboard.SDLK_RIGHT)) then
                if (hasNextFrame) then
                    t = 0.0
                    currentFrame = currentFrame + 1
                    direction = 1
                    animate = true
                end
                print("currentFrame: ", currentFrame)
            end

            if (e:IsKeyPressed(Keyboard.SDLK_LEFT)) then
                if (currentFrame > 1) then
                    t = 1.0
                    currentFrame = currentFrame - 1
                    direction = -1
                    animate = true
                end
                print("currentFrame: ", currentFrame)
            end

            ---
            ---
            --- This is for External State management
            ---
            ---

            local newcurrentFrame, newdirection, newshouldRun, newt, newanimate =
                PresentationEventFunction(
                    currentFrame,
                    direction,
                    shouldRun,
                    t,
                    animate)

            direction = newdirection
            shouldRun = newshouldRun
            t = newt
            animate = newanimate

            if newcurrentFrame <= gFrameCount and newcurrentFrame >= 1 then
                currentFrame = newcurrentFrame
            end

            ---
            ---
            --- This is for External State management
            ---
            ---

            if (e:IsCloseWindowEvent()) then
                shouldRun = false
            end
            gwid:Event()
        end



        local function Update()
            gwid:Update()
            hasNextFrame = ExecuteFrame(inPresentation, currentFrame, t, direction)
            if w:GetWindowCurrentTime() - currentTime > stepTime then
                if animate then
                    t = t + direction * (stepTime + residualTime)
                    if t <= 0.0 or t >= 1.0 then
                        animate = false
                        if t <= 0.0 then
                            t = 0.0
                        else
                            t = 1.0
                        end
                    end
                end
                residualTime = (w:GetWindowCurrentTime() - currentTime) / 1000
                currentTime = w:GetWindowCurrentTime()
            else
                residualTime = residualTime / 1000 + stepTime -
                    (w:GetWindowCurrentTime() - currentTime) / 1000
            end
        end

        local function Dispatch()
            gwid:Dispatch()
        end

        local function Draw()
            gwid:Draw()
        end

        local function MultiThreadedDraws()
        end

        local function MultiThreadedExecute()
        end

        e:SetEventCallBack(Event)
        while shouldRun do
            oldTime = w:GetWindowCurrentTime()
            e:ProcessEventsEXT(gwindow)
            w:BeginUpdates()
            Update()
            gWindowDimension = w:GetWindowDimension()
            w:EndUpdates()

            w:BeginDispatches()
            Dispatch()
            w:EndDispatches()

            MultiThreadedDraws()
            w:BeginUIs()
            Draw()
            w:EndUIs()

            w:BeginDraws(WindowClearColor.x, WindowClearColor.y, WindowClearColor.z,
                WindowClearColor.w, 1)
            MultiThreadedExecute()
            w:ExecuteUIs()
            w:EndDraws()
            w:Present()
            local delta = w:GetWindowCurrentTime() - oldTime
            if (frameCount % 100 == 0) then
                w:SetTitle("JkrGUI Present : " .. 1000 / delta)
            end
            frameCount = frameCount + 1
        end
        w:Hide()
    end
end


function DefaultPresentation()
    local o = {
        Config = {
            Font = {
                Tiny = { "res/fonts/font.ttf", 10 },     -- \tiny
                Small = { "res/fonts/font.ttf", 12 },    -- \small
                Normal = { "res/fonts/font.ttf", 16 },   -- \normalsize
                large = { "res/fonts/font.ttf", 20 },    -- \large
                Large = { "res/fonts/font.ttf", 24 },    -- \Large
                huge = { "res/fonts/font.ttf", 28 },     -- \huge
                Huge = { "res/fonts/font.ttf", 32 },     -- \Huge
                gigantic = { "res/fonts/font.ttf", 38 }, -- \gigantic
                Gigantic = { "res/fonts/font.ttf", 42 }, -- \Gigantic
            }
        },
        Animation {
            Interpolation = "Constant",
        },
        insert = table.insert
    }
    return o
end
