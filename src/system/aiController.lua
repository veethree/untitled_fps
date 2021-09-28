return {
    filter = function(e)
        return e._TYPE == "mob"
    end,

    process = function(e, dt)
        local player = state:get_state().player
        local map = state:get_state().map
        local x, y = floor(e.position[1] + 0.5), floor(e.position[2] + 0.5)
        local px, py = floor(player.position[1] + 0.5), floor(player.position[2] + 0.5)
        

        local visible = bresenham.los(x, y, px, py, function(a, b)
            if type(map[b][a]) == "number" then
                if map[b][a] < 1 then
                    return true
                else
                    return false 
                end
            end
        end)

        if visible then
            e.mode = "chase"
        else
            e.mode = "idle"
        end
    end
}