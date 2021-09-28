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

    --Exposing the player for debug purposes
    _PLAYER = self.player

    --
    self.crosshair = {
        size = floor(lg.getHeight() * 0.01),
        color = {1, 1, 1, 1}
    }


    self.bgCanvas = lg.newCanvas()
    self.fgCanvas = lg.newCanvas()
    self.screenCanvas = lg.newCanvas() -- Combines bg and fg so shaders can  be aplied to both

    self.sobelCanvas = lg.newCanvas()

    self.sobel = fs.load("src/assets/shader/sobel.lua")()
    self.sobel:send("image_size", {lg.getWidth(), lg.getHeight()})
    self.sobel:send("kernel", -1, -1, -1, -1, 8, -1, -1, -1, -1)

    self.blur = fs.load("src/assets/shader/blur.lua")()
    self.blur:send("image_size", {lg.getWidth(), lg.getHeight()})
    self.blur:send("intensity", 2)

    -- Camera zoom
    self.camera = {
        fov = math.pi / 2
    }

    self.target_camera = {
        fov = math.pi / 2
    }
    smoof:new(self.camera, self.target_camera, 0.001, 0.001, true)
    --function smoof:new(object, target, smoof_value, completion_threshold, bind, callback)

    self.flash = 1
    self.flash_speed = 2
    self.postShader = fs.load("src/assets/shader/post.lua")()
    self.postShader:send("intensity", self.flash)
end

function game:update(dt)
    if lm.isDown(2) then
        self.target_camera.fov = math.pi / 8
    else
        self.target_camera.fov = math.pi / 2
    end
    
    g3d.camera.setFov(self.camera.fov)

    smoof:update(dt)

    --Shader
    self.flash = self.flash - self.flash_speed * dt
    if self.flash < 1 then self.flash = 1 end
    self.postShader:send("intensity", self.flash)

    g3d.camera.firstPersonMovement(dt)
end

function game:draw()
    lg.setBlendMode("alpha")

    local dt = love.timer.getDelta()
    lg.setCanvas({self.bgCanvas, depth = true})
    lg.clear()
    self.world:update(dt)
    lg.setCanvas()

    -- Drawing to screen canvas
    lg.setColor(1, 1, 1, 1)
    lg.setCanvas(self.screenCanvas)
    lg.clear()
    lg.draw(self.bgCanvas)
    lg.draw(self.fgCanvas)
    lg.setCanvas()
    

    -- Creating outline canvas
    lg.setCanvas(self.sobelCanvas)
    lg.clear()
    lg.setShader(self.sobel)
    lg.draw(self.screenCanvas)
    lg.setShader()
    lg.setCanvas()
    
    lg.setShader(self.postShader)
    lg.draw(self.screenCanvas)
    lg.setShader()


    -- CELL SHADE
    if config.graphics.cell_shade then
        lg.setBlendMode("multiply", "premultiplied")
        lg.draw(self.sobelCanvas)
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

function game:mousepressed(x, y, key)
    if key == 1 then
        local bullet = self.world:newEntity("src/entity/bullet.lua")
        --(position, direction, scale)
        local x, y, z = unpack(self.player.position)
        local rx, ry ,rz = g3d.camera.getLookVector()
        local direction = {rx, ry, rz}
        bullet:init({x, y, z}, direction)
        self.flash = 1.2
    end
end

function game:keypressed(key)
    if key == "tab" then
        self.player.visible = not self.player.visible
    end
end

return game