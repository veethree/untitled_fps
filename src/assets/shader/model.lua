local basic_shading = [[
    varying vec4 worldPosition;
    varying vec4 viewPosition;
    varying vec4 screenPosition;
    varying vec3 vertexNormal;
    varying vec4 vertexColor;
    extern vec3 player;
    extern number falloff;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        number d = distance(player, vec3(worldPosition[0], worldPosition[1], worldPosition[2]));
        pixel = (pixel /  falloff) * (falloff - d);
        return vec4(pixel.r, pixel.g, pixel.b, 1.0);
    }

]]

local fog = [[
    varying vec4 worldPosition;
    extern vec3 player;
    extern number fog_min;
    extern number fog_max;
    extern vec4 fog_color;
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        number d = distance(player, vec3(worldPosition[0], worldPosition[1], worldPosition[2]));
        number amount = smoothstep(fog_min, fog_max, d);
        return mix(pixel, fog_color, amount);
    }

]]
local shader = lg.newShader("src/class/g3d/g3d.vert", fog)
return shader
