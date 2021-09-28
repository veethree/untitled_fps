return {
    filter = function(e)
        return e._TYPE == "mob" and e.mode == "wander" or false
    end,

    process = function(e, dt)
        e.time = e.time + 1 * dt
        
        local speed = 0.01
        local angle = (math.pi * 2) * noise(e.time)

        local x, y, z = unpack(e.position)

        newX = x + speed * cos(angle)
        newY = y + speed * sin(angle)

        e.position = {newX, newY, z}

        e.model:setTranslation(unpack(e.position))
    end
}