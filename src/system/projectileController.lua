return {
    filter = function(e)
        if e._TYPE == "projectile" then return true else return false end
    end,

    process = function(e, dt)
        local x, y, z = unpack(e.position)
        local dx, dy, dz = unpack(e.direction)

        local newX, newY, newZ = x, y, z

        if not e.stop then
            newX = x + dx * e.speed * dt
            newY = y + dy * e.speed * dt
            newZ = z + dz * e.speed * dt
        end

        local col_objects, len = e.world:getEntities(function(b) return b.shootable or false end)

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

        --Floor & ceiling check
        if newZ < -0.5 or newZ > 0.5 then
            col = true
        end

        if col then
            e._REMOVE = true
        end

        e.model:setTranslation(newX, newY, newZ)
        
    end
}