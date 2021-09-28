local object = {
    _TYPE = "object",
    visible = false,
    shootable = true,
    draw = function(e)
        --lg.setColor(1, 1, 1, 1)
        e.model:draw()
    end
}

--
function object:init(object, position, rotation, scale)
    position = position or {0, 0, 0}
    rotation = rotation or {0, 0, 0}
    scale = scale or {1, 1, 1}
    --model = g3d.newModel(mesh, texture, translation, rotation, scale).
    self.model = g3d.newModel(f("src/assets/model/%s.obj", object), _TEXTURE["palette2"], position, rotation, scale)
    self.position = position
    self.visible = true
    
    self.solid = true
end

return object