local robot = {
    _TYPE = "mob",
    visible = true,
    scale = 0.4,
    shootable = true,
    mode = "idle",
    time = 0,
    draw = function(e)
        e.model:draw()
    end
}

function robot:init(position, rotation, scale)
    position = position or {0, 0, 0}
    rotation = rotation or {0, 0, 0}
    scale = scale or {self.scale, self.scale, self.scale}
    --model = g3d.newModel(mesh, texture, translation, rotation, scale).
    local model = "evilRobot_attack.obj"
    self.model = deepcopy(_MODEL["evilRobot_attack"])--g3d.newModel(f("src/assets/model/%s", model), _TEXTURE["palette2"], position, rotation, scale)
    self.model:setTexture(_TEXTURE["palette2"])
    self.model:setTransform(position, rotation, scale)

    self.position = position
    self.rotation = rotation
    self.visible = true
end

return robot