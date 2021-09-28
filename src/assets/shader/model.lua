local pixel = [[
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
        pixel.rgb = (pixel.rgb / falloff) * (falloff - d);
        return pixel;
    }

]]
local shader = lg.newShader("src/class/g3d/g3d.vert", pixel)
return shader
