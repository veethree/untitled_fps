-- Various utility functions

function require_folder(folder)
    if fs.getInfo(folder) then
        for i,v in ipairs(fs.getDirectoryItems(folder)) do
            if fs.getInfo(folder.."/"..v).type == "file" then
                if get_file_type(v) == "lua" then
                    _G[get_file_name(v)] = require(folder.."."..get_file_name(v))
                end
            end
        end
    else
        error(string.format("Folder '%s' does not exists", folder))
    end
end

function hasValue(t, val)
    for k,v in pairs(t) do
        if v == val then return true end
    end
end

function get_file_type(file_name)
    return string.match(file_name, "%..+"):sub(2)
end

function get_file_name(file_name)
    return string.match(file_name, ".+%."):sub(1, -2)
end

-- Converts colors from 0-255 to 0-1
function color(r, g, b, a)
    a = a or 255
    return r / 255,  g / 255,  b / 255,  a / 255
end

function angle(x1,y1, x2,y2)
    return math.atan2(y2-y1, x2-x1)
end