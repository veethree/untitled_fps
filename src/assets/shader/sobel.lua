return lg.newShader([[
    extern vec2 image_size;
    extern float kernel[9];
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 sum = vec4(0.0);
        vec2 step_size = 1.0 / image_size;

        sum += Texel(tex, vec2(tc.x - step_size.x, tc.y - step_size.y)) * kernel[0];
        sum += Texel(tex, vec2(tc.x, tc.y - step_size.y)) * kernel[1];
        sum += Texel(tex, vec2(tc.x + step_size.x, tc.y - step_size.y)) * kernel[2];

        sum += Texel(tex, vec2(tc.x - step_size.x, tc.y)) * kernel[3];
        sum += Texel(tex, vec2(tc.x, tc.y)) * kernel[4];
        sum += Texel(tex, vec2(tc.x + step_size.x, tc.y)) * kernel[5];

        sum += Texel(tex, vec2(tc.x - step_size.x, tc.y + step_size.y)) * kernel[6];
        sum += Texel(tex, vec2(tc.x, tc.y + step_size.y)) * kernel[7];
        sum += Texel(tex, vec2(tc.x + step_size.x, tc.y + step_size.y)) * kernel[8];

        number avg = sum[1] + sum[2] + sum[3] / 3;

        return vec4(1 - avg, 1 - avg, 1 - avg, 1);
    }

]])
