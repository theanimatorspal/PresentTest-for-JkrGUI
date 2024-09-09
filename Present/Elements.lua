require("JkrGUIv2.Engine.Shader")

function Default(inTable, def)
    if type(inTable) == "table" and type(def) == "table" then
        for key, value in pairs(def) do
            inTable[key] = Default(inTable[key], value)
        end
        return inTable
    else
        return inTable or def
    end
end

Frame = function(inTable)
    return { Frame = inTable }
end

TitlePage = function(inTable) return { TitlePage = inTable } end

Enumerate = function(inTable) return { Enumerate = inTable } end

Animation = function(inStyle) return { Style = inStyle } end

Item = function(inStr)
    return inStr
end

Text = function(inText)
    return {
        Text = Default(inText,
            {
                t = "JkrGUIv2",
                f = "Normal",
                p = "CENTER_CENTER",
                c = vec4(1, 1, 1, 1)
            }
        )
    }
end

CImage = function(inTable, inP, inD)
    if not inP then inP = "CENTER_CENTER" end
    if not inD then inD = vec2(500, 500) end
    local def = {
        shader = "",
        shader_parameters = {
            threads = vec3(500, 500, 1),
            p1 = vec4(0.0, 0.0, 1, 1),
            p2 = vec4(0, 0, 0, 0),
            p3 = vec4(0, 0, 0, 0),
        },
        p = inP,
        d = inD
    }
    return { CImage = Default(inTable, def) }
end

Button = function(inButtonTable)
    local t = {
        p = "CENTER_CENTER",
        d = vec3(100, 50, 1)
    }
    return { Button = Default(inButtonTable, t) }
end

ButtonText = function(inButtonTextTable)
    local t = {
        t = "Button",
        p = "CENTER_CENTER",
        d = vec3(100, 50, 1),
        f = "Normal",
        c = vec4(1, 1, 1, 1)
    }
    return { ButtonText = Default(inButtonTextTable, t) }
end

local Shaders = {
    Plotter = {
        cs = Engine.Shader()
            .Header(450)
            .CInvocationLayout(1, 1, 1)
            .uImage2D()
            .ImagePainterPush()
            .Append [[
        float plot(vec2 st, float fx, float inthickness) {
                return smoothstep(fx - inthickness, fx, st.y) -
                smoothstep(fx, fx + inthickness, st.y);
        }
        ]]
            .GlslMainBegin()
            .ImagePainterAssist()
            .Append [[
        float x = xy.x;
        float y = xy.y;
        float fx = sin(x);
        float pl = plot(vec2(x, y), fx, 0.01);
        // imageStore(storageImage, to_draw_at,  vec4(pl, 0, 0, 1));
        imageStore(storageImage, to_draw_at,  vec4(1, 1, 1, 1));
        ]]
            .GlslMainEnd().str
    }
}

Shader = function(inTable, inBuiltinShaderOpt)
    if inBuiltinShaderOpt then
        return { Shader = Shaders[inBuiltinShaderOpt] }
    end
    return { Shader = inTable }
end
