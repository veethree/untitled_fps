return lg.newShader([[
    extern number factor;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        pixel.r = pixel.r - (1.0 - pixel.r) * factor;
        pixel.g = pixel.g - (1.0 - pixel.g) * factor;
        pixel.b = pixel.b - (1.0 - pixel.b) * factor;
        return pixel;
    }
]])
