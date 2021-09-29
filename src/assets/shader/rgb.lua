
return lg.newShader([[
    extern number intensity;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        number d = distance(tc, vec2(0.5, 0.5)) * intensity;
        return vec4(Texel(tex, vec2(tc.x - d, tc.y)).r, Texel(tex, tc).g, Texel(tex, vec2(tc.x + d, tc.y)).b, 1.0);
    }
]])

