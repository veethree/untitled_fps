
return lg.newShader([[
    extern number intensity;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        pixel.r = pixel.r * 0.9;
        pixel.b = pixel.b * 1.2;
        return pixel * intensity;
    }
]])

