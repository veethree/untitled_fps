-- This system handels rendering object

return {
    filter = function(e)
        return e.visible or false
    end,

    process = function(e)
        local map = state:get_state().map
        local player = state:get_state().player
        local d = e.model:getDistanceFrom(unpack(player.position))
        if e.draw then
            local px, py = floor(player.position[1] + 0.5), floor(player.position[2] + 0.5)
            local x, y = e.position[1], e.position[2]

            local visible = true
            local sx, sy = x, y
            if e._TYPE == "tile" and not e.flat then
                if x < px then
                    sx = x + 1
                elseif x > px then
                    sx = x - 1
                end
                if y < py then
                    sy = y + 1
                elseif y > py then
                    sy = y - 1
                end
                visible = bresenham.los(sx, sy, px, py, function(a, b)
                    if map[b][a] == 0 then
                        return true
                    else
                        return false
                    end
                end)
            end

   
            if d < config.graphics.render_distance and not e.flat then 
                lg.setColor(1, 1, 1, 1)
                e.draw(e)
                _RENDERED = _RENDERED + 1
            end

            if e.flat then
                lg.setColor(1, 1, 1, 1)
                e.draw(e)
            end
        end
    end}

-- local A = bresenham.los(2,2,6,6, function(x,y)
--     if map[x][y] == '#' then return false end
--     map[x][y] = 'A'
--     return true
--   end)