require "JkrGUIv2.Widgets.General"
require "JkrGUIv2.Engine.Engine"
Engine:Load(true)
local framed = vec2(200, 400)
local w = Jkr.CreateWindow(Engine.i, "Hello Anroid", vec2(400, 700), 3, framed)
local e = Engine.e
local gwr = Jkr.CreateGeneralWidgetsRenderer(nil, Engine.i, w, e)
local f = gwr.CreateFont("res/fonts/font.ttf", 14)

e:SetEventCallBack(
    function()
        gwr:Event()
    end
)
local Background = gwr.CreatePressButton(vec3(0, 0, 50), vec3(100, 100, 1),
    function() end,
    false, f,
    "", vec4(0),
    vec4(0.5, 0.8, 0.95, 1))
Background:Update(vec3(-20, -20, 50), vec3(framed.x + 40, framed.y + 40, 1))

local DisplayText = " "
local Display = gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
    function() end,
    false, f,
    DisplayText,
    vec4(1, 1, 0, 1))

local UpdateDisplay = function()

end


local Clear = gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1),
    function()
        DisplayText = " "
        UpdateDisplay()
    end,
    false, f,
    "Clear",
    vec4(0.2, 0.4, 0, 1))



local cpbf = function(inTextToAppend)
    return gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), function()
            DisplayText = DisplayText .. inTextToAppend
            UpdateDisplay()
        end,
        false, f,
        inTextToAppend,
        vec4(0.5, 0, 0, 1), vec4(1, 1, 1, 0.8))
end

local spbf = function(inText)
    return gwr.CreatePressButton(vec3(math.huge, math.huge, 20), vec3(100, 100, 1), function() print(inText) end, false,
        f,
        inText,
        vec4(0, 0, 0, 1), vec4(1, 1, 1, 0.8))
end

local ScreenVLayout = Jkr.VLayout:New(0)

local TopInfoHLayout_1 = Jkr.HLayout:New(0)
TopInfoHLayout_1:AddComponents({ spbf("Write"), spbf("IP"), Clear }, { 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0 })

local DisplayHLayout_2 = Jkr.HLayout:New(0)
DisplayHLayout_2:AddComponents(
    { Display },
    { 1 }
)


local NRatioTable = { 1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0 }
local NumericHLayout_3 = Jkr.HLayout:New(0)
NumericHLayout_3:AddComponents({ cpbf("1"), cpbf("2"), cpbf("3") }, NRatioTable)

local NumericHLayout_4 = Jkr.HLayout:New(0)
NumericHLayout_4:AddComponents({ cpbf("4"), cpbf("5"), cpbf("6"), }, NRatioTable)

local NumericHLayout_5 = Jkr.HLayout:New(0)
NumericHLayout_5:AddComponents({ cpbf("7"), cpbf("8"), cpbf("9"), }, NRatioTable)

local NumericHLayout_6 = Jkr.HLayout:New(0)
NumericHLayout_6:AddComponents({ cpbf("."), cpbf("0"), spbf("Submit"), }, NRatioTable)

ScreenVLayout:AddComponents({
    TopInfoHLayout_1,
    DisplayHLayout_2,
    NumericHLayout_3,
    NumericHLayout_4,
    NumericHLayout_5,
    NumericHLayout_6
}, { 0.1, 0.3, 0.15, 0.15, 0.15, 0.15 })

ScreenVLayout:Update(vec3(0, 0, 20), vec3(framed.x, framed.y, 1))

UpdateDisplay = function()
    Display:Update(vec3(20), vec3(0), f, DisplayText, vec4(0.2, 0.4, 0, 1))
    ScreenVLayout:Update(vec3(0, 0, 20), vec3(framed.x, framed.y, 1))
end

while not e:ShouldQuit() do
    e:ProcessEventsEXT(w)
    w:BeginUpdates()
    gWindowDimension = w:GetWindowDimension()
    gwr:Update()
    w:EndUpdates()

    w:BeginDispatches()
    gwr:Dispatch()
    w:EndDispatches()

    w:BeginUIs()
    gwr:Draw()
    w:EndUIs()

    w:BeginDraws(0, 0, 0, 1, 1)
    w:ExecuteUIs()
    w:EndDraws()
    w:Present()
end
