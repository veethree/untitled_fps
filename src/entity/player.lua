local player = {
    _TYPE = "player",
    visible = false,
    control = true,
    scale = 0.5,
    speed = 2.5,
    move = 0,
    draw = function(e)
        lg.setColor(1, 1, 1, 1)
        --e.model:draw()

        local x, y, z = unpack(e.position)
        local dist = 0.6
        local a, b = g3d.camera.getDirectionPitch()
        a = a % (math.pi * 2)
    
        local gx = x + dist * cos(a - 0.2)
        local gy = y + dist * sin(a)
        local gz = z + dist * b 
        e.gun:setTransform({gx, gy, gz - (0.25 + (0.01 * sin(e.move)))}, {-math.pi / 2, b, a - math.pi})

        local oc = lg.getCanvas()
        lg.setCanvas({state:get_state().fgCanvas, depth=true})
        lg.clear()
        e.gun:draw()
        lg.setCanvas(oc)

    end
}

function player:init(position, rotation, scale)
    position = position or {0, 0, 0}
    rotation = rotation or {0, 0, 0}
    scale = scale or {self.scale, self.scale, self.scale}
    --model = g3d.newModel(mesh, texture, translation, rotation, scale).
    local model = "cube.obj"
    self.model = g3d.newModel(f("src/assets/model/%s", model), _TEXTURE["error"], position, rotation, scale)

    self.gun = g3d.newModel("src/assets/model/pistol.obj", _TEXTURE["palette"], nil, nil, {0.05, 0.05, 0.05})

    self.position = position
    self.visible = true
end

return player