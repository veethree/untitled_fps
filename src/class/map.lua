-- Loads maps :)

local map = {}

function map.init()
     -- This table maps textures to tile id's
    map.tile_texture = {}
    map.tile_texture[1] = _TEXTURE["wall"]
    map.tile_texture[2] = _TEXTURE["glass"]
    -- This table maps entities to tile id's
    map.entity_type = {}
    map.entity_type[1] = "spawn_point"
    map.entity_type[2] = "table"

end

function map.tileTexture(tex, width, height)
    local texture = lg.newCanvas(width * _ASSET_SIZE, height * _ASSET_SIZE)
    
    local oc = lg.getCanvas()
    lg.setCanvas(texture)
    lg.setColor(1, 1, 1, 1)
    for y=1, height do
        for x=1, width do
            lg.draw(tex, (x - 1) * _ASSET_SIZE, (y - 1) * _ASSET_SIZE)
        end
    end
    lg.setCanvas(oc)

    return texture
end

function map.load(path, world)
    assert(fs.getInfo(path), f("'%s' doesn't exist!", path))
    local map_data = {}
    local mapFile = fs.load(path)()
    local tile_layer = mapFile.layers[1]
    local entity_layer = mapFile.layers[2]

    local spawn_point = {0, 0, 0}

    -- Tile layer
    for y=1, tile_layer.height do
        map_data[y] = {}
        for x=1, tile_layer.width do
            local index = tile_layer.height * (y - 1) + x
            local tile = tile_layer.data[index]
            map_data[y][x] = tile

            if tile > 0 then
                local tile_entity = world:newEntity("src/entity/tile.lua")
                local scale = {1, 1, 1}
                if tile == 2 then
                    scale = {1, 0.5, 1}
                end
                tile_entity:init(map.tile_texture[tile], {x, y, 0}, nil, scale)
            end
        end
    end

    -- Entity layer
    for y=1, entity_layer.height do
        for x=1, entity_layer.width do
            local index = entity_layer.height * (y - 1) + x
            local entity = map.entity_type[entity_layer.data[index]]

            if entity_layer.data[index] > 0 then
                if entity == "spawn_point" then
                    spawn_point[1] = x
                    spawn_point[2] = y
                elseif entity == "table" then
                    local table = world:newEntity("src/entity/object.lua")
                    --(object, position, rotation, scale)
                    table:init("table", {x, y, 0}, {-math.pi / 2, 0, -math.pi / 2})
                    print(entity)
                end
            end
        end
    end

    -- Floor
    local floor_texture = map.tileTexture(_TEXTURE["floor"], tile_layer.width, tile_layer.height)
    local floor = world:newEntity("src/entity/tile.lua")
    floor:init(floor_texture, {tile_layer.width / 2 + 0.5, tile_layer.width / 2 + 0.5, -0.5}, {math.pi / 2, 0, 0}, {tile_layer.width, 1, tile_layer.height}, true)

    -- Ceiling
    local ceiling_texture = map.tileTexture(_TEXTURE["ceiling"], tile_layer.width, tile_layer.height)
    local ceiling = world:newEntity("src/entity/tile.lua")
    ceiling:init(ceiling_texture, {tile_layer.width / 2 + 0.5, tile_layer.width / 2 + 0.5, 0.5}, {math.pi / 2, 0, 0}, {tile_layer.width, 1, tile_layer.height}, true)

    return map_data, spawn_point
end

return map