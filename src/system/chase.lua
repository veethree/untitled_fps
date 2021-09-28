return {
    filter = function(e)
        return e._TYPE == "mob" and e.mode == "chase" or false
    end,

    process = function(e, dt)
        local player = state:get_state().player
        
        local speed = 2
        
        local x, y, z = unpack(e.position)
        local rx, ry, rz = unpack(e.rotation)
        local a = angle(x, y, player.position[1], player.position[2])

        local newX = x + speed * cos(a) * dt
        local newY = y + speed * sin(a) * dt

        local fixed_x, fixed_y = collision.move(e, {newX, newY, z})

        e.position = {fixed_x, fixed_y, z}

        e.model:setRotation(rx, ry, a)
        e.model:setTranslation(unpack(e.position))
    end
}