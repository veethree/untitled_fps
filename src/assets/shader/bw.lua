return lg.newShader([[
    extern number factor;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        number average = (pixel.r + pixel.g + pixel.b) / 3.0;
        pixel.r = pixel.r + (average - pixel.r) * factor;
        pixel.g = pixel.g + (average - pixel.g) * factor;
        pixel.b = pixel.b + (average - pixel.b) * factor;
        return pixel;
    }
]])
