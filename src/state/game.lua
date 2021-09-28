local game = {}

function game:load(data)
    self.world = ecs.newWorld()
    self.world:newSystem(ecs.loadFolder("src/system"))
    --Exposing self.world for debug purposes
    if config.debug.enabled then
        _WORLD = self.world
    end

    --Loading map
    local map_data, spawn_point = map.load("src/map/testMap2.lua", self.world)
    self.map = map_data

    -- Loading player
    self.player = self.world:newEntity("src/entity/player.lua")
    self.player:init(spawn_point)

    --
    self.crosshair = {
        size = floor(lg.getHeight() * 0.01),
        color = {1, 1, 1, 1}
    }


    self.mainCanvas = lg.newCanvas()
    self.fgCanvas = lg.newCanvas()

    self.shaderCanvas = lg.newCanvas()

    self.sobel = fs.load("src/assets/shader/sobel.lua")()
    self.sobel:send("image_size", {lg.getWidth(), lg.getHeight()})
    self.sobel:send("kernel", -1, -1, -1, -1, 8, -1, -1, -1, -1)
    
end

function game:update(dt)
    smoof:update(dt)

    g3d.camera.firstPersonMovement(dt)
end

function game:draw()
    lg.setBlendMode("alpha")

    local dt = love.timer.getDelta()
    lg.setCanvas({self.mainCanvas, depth = true})
    lg.clear()
    self.world:update(dt)
    lg.setCanvas()


    lg.setColor(1, 1, 1, 1)
    lg.setCanvas(self.shaderCanvas)
    lg.clear()
    lg.draw(self.mainCanvas)
    lg.draw(self.fgCanvas)
    lg.setCanvas()

    lg.draw(self.shaderCanvas)

    -- CELL SHADE
    if config.graphics.cell_shade then
        lg.setBlendMode("multiply", "premultiplied")
        lg.setShader(self.sobel)
        lg.setColor(1, 1, 1, 0.1)
        lg.draw(self.shaderCanvas)
        lg.setShader()
    end

    --minimap
    local scale = 3
    for y=1, #self.map do
        for x=1, #self.map[y] do
            local c = self.map[y][x]
            lg.setColor(c, c, c, 1)
            local px, py = floor(self.player.position[1] + 0.5), floor(self.player.position[2] + 0.5)
            
            if x == px and y == py then
                lg.setColor(1, 0, 1, 1)
            end
            lg.rectangle("fill", (x - 1) * scale, (y - 1) * scale, scale, scale)
        end
    end
    
    lg.setBlendMode("alpha")
    lg.setColor(self.crosshair.color)
    lg.circle("line", lg.getWidth() / 2, lg.getHeight() / 2, self.crosshair.size)


end

function game:mousemoved(x, y, dx, dy)
    --print("LOVE: ", dx, dy)
    --g3d.camera.firstPersonLook(dx, dy)
end

function game:keypressed(key)
    if key == "tab" then
        self.player.visible = not self.player.visible
    end
end

return game