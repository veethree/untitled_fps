
return lg.newShader([[
    extern number intensity;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        //pixel.g = pixel.g * 0.7;
        //pixel.b = pixel.b * 0.5;
        return pixel * intensity;
    }
]])

