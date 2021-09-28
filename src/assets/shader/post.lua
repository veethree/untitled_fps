
return lg.newShader([[
    extern number intensity;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        return Texel(tex, tc) * intensity;
    }
]])

