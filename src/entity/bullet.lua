local bullet = {
    _TYPE = "projectile",
    visible = false,
    projectile = true,
    speed = 10,
    scale = 0.2,
    stop = false,
    draw = function(e)
        e.model:draw()
    end
}

function bullet:init(position, direction, scale)
    position = position or {0, 0, 0}
    direction = direction or {0, 0, 0}
    scale = scale or {self.scale, self.scale, self.scale}
    --model = g3d.newModel(mesh, texture, translation, rotation, scale).
    local dir, pitch = g3d.camera.getDirectionPitch()
    local rotation = {pitch, 0, dir - (math.pi / 2)}
    self.model = g3d.newModel("src/assets/model/bullet.obj", _TEXTURE["palette2"], position, rotation, scale)

    self.position = position
    self.direction = direction
    self.visible = true
end

return bullet