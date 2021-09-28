local tile = {
    _TYPE = "tile",
    visible = false,
    shootable = true,
    draw = function(e)
        --lg.setColor(1, 1, 1, 1)
        e.model:draw()
    end
}

--
function tile:init(texture, position, rotation, scale, flat)
    position = position or {0, 0, 0}
    rotation = rotation or {0, 0, 0}
    scale = scale or {1, 1, 1}
    flat = flat or false
    --model = g3d.newModel(mesh, texture, translation, rotation, scale).
    local model = "cube.obj"
    if flat then model = "plane.obj" end
    self.model = g3d.newModel(f("src/assets/model/%s", model), texture, position, rotation, scale)
    self.position = position
    self.visible = true
    self.flat = flat
    
    self.solid = true
    if flat then self.solid = false end
end

return tile