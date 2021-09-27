return {
    filter = function(e)
        return e.control or false
    end,

    process = function(e, dt)
        local look_sensitivity = 2
        -- Camera look
        
        -- collect inputs
        local moveX, moveY = 0, 0
        local newX = e.position[1]
        local newY = e.position[2]
        if love.keyboard.isDown "w" then moveX = moveX + 1 end
        if love.keyboard.isDown "a" then moveY = moveY + 1 end
        if love.keyboard.isDown "s" then moveX = moveX - 1 end
        if love.keyboard.isDown "d" then moveY = moveY - 1 end
        
        -- if love.keyboard.isDown "space" then
        --     e.position[3] = e.position[3] + e.speed*dt
        -- end
        -- if love.keyboard.isDown "lshift" then
        --     e.position[3] = e.position[3] - e.speed*dt
        -- end
        
        -- do some trigonometry on the inputs to make movement relative to e's direction
        -- also to make the player not move faster in diagonal directions
        
        local direction, pitch = g3d.camera.getDirectionPitch()
        if moveX ~= 0 or moveY ~= 0 then
            local angle = math.atan2(moveY, moveX)
            newX = newX + math.cos(direction + angle) * e.speed * dt
            newY = newY + math.sin(direction + angle) * e.speed * dt
        end

        -- Collision code

        local col_objects, len = e.world:getEntities(function(b) return b.solid or false end)

        local col = false
        local closest = 10000
        local col_scale = e.scale / 4
        for i,v in ipairs(col_objects) do
            --Model:sphereIntersection(src_x, src_y, src_z, radius)
            local len, x, y, z, nx, ny, nz = v.model:sphereIntersection(newX, newY, e.position[3], col_scale)
            if len then
                if len < closest then
                    closest = len
                    col = {v, len, x, y, z, nx, ny, nz}
                end
            end
        end

        local fixed_x, fixed_y = newX, newY
        if col then
            -- lg.print("L: " ..col[2], 12, 80)
            -- lg.print("X: " ..col[3], 12, 100)
            -- lg.print("Y: " ..col[4], 12, 120)
            -- lg.print("Z: " ..col[5], 12, 140)

            -- lg.print("NX: " ..col[6], 12, 160)
            -- lg.print("NY: " ..col[7], 12, 180)
            -- lg.print("NZ: " ..col[8], 12, 200)

            local other = col[1]
            local len = col[2] - (col_scale) + 0.01

            local function fix_x(col)
                if col[6] < 0 then
                    fixed_x = col[3] - ((col_scale))
                elseif col[6] > 0 then
                    fixed_x = col[3] + ((col_scale))
                end
            end

            local function fix_y(col)
                if col[7] < 0 then
                    fixed_y = col[4] - ((col_scale))
                elseif col[7] > 0 then
                    fixed_y = col[4] + ((col_scale))
                end
            end


            if col[6] ~= 0 and col[7] ~= 0 then
                if col[6] > col[7] then
                    fix_y(col)
                else
                    fix_x(col)
                end
            else
                fix_x(col)
                fix_y(col)
            end

            
        end
        
        e.position[1] = fixed_x
        e.position[2] = fixed_y
        e.model:setTranslation(unpack(e.position))
        g3d.camera.firstPersonLook(_MOUSE_X * look_sensitivity, _MOUSE_Y * look_sensitivity)

        local x, y, z = unpack(e.position)
        g3d.camera.lookInDirection(x,y,z)

    end
}