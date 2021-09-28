local collision = {}

function collision.move(entity, newPosition)
    local newX, newY = unpack(newPosition)

    local col_objects, len = entity.world:getEntities(function(b) return b.solid and distance(newX, newY, b.position[1], b.position[2]) < 5 end)

    local col = false
    local closest = 10000
    local col_scale = entity.scale / 4
    for i,v in ipairs(col_objects) do
        --Model:sphereIntersection(src_x, src_y, src_z, radius)
        local len, x, y, z, nx, ny, nz = v.model:sphereIntersection(newX, newY, entity.position[3], col_scale)
        if len then
            if len < closest then
                closest = len
                col = {v, len, x, y, z, nx, ny, nz}
            end
        end
    end

    local fixed_x, fixed_y = newX, newY
    if col then
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

    return fixed_x, fixed_y
end

return collision