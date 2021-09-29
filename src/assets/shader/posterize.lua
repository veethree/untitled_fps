
return lg.newShader([[
    extern number colors;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        pixel = floor(pixel * colors) / colors;
        return pixel;
    }
]])

