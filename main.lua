NAME = "Untitled"
VERSION = 0.1
 
-- GLOBALS
lg = love.graphics
fs = love.filesystem
lk = love.keyboard
random = math.random
noise = love.math.noise
sin = math.sin
cos = math.cos
floor = math.floor
ceil = math.ceil
f = string.format


function love.load()
    -- Loaidng classes
    require("src.class.util")
    require_folder("src/class")

    exString.import()

    --Global keypress events love.system.openURL("file://"..love.filesystem.getSaveDirectory())
    keybind:new("keypressed", {"escape"}, love.event.push, "quit")
    keybind:new("keypressed", {"escape","lshift"}, love.system.openURL, "file://"..love.filesystem.getSaveDirectory())

    -- Defining states
    state:define_state("src/state/game.lua", "game")

    --Config
    default_config = {
        window = {
            width = 1024,
            height = 576,
            fullscreen = false,
            title = NAME.." ["..VERSION.."]"
        },
        debug = {
            enabled = true,
            text_color = {0, 0, 0}
        }
    }

    config = default_config
    if fs.getInfo("config.lua") then
        --config = ttf.load("config.lua")
    else
        save_config()
    end

    -- Creating window
    love.window.setMode(config.window.width, config.window.height, {fullscreen=config.window.fullscreen, vsync = false})
    love.window.setTitle(config.window.title)

    --Graphics setup
    lg.setDefaultFilter("nearest", "nearest")

    --Scaling
    scale_x = lg.getWidth() * 0.001
    scale_y = lg.getHeight() * 0.001

    --Loading fonts
    font = {
        regular = lg.newFont("src/assets/font/monogram.ttf", 42 * scale_x)
    }

    --Loading textures
    _TEXTURE = {}
    for i,v in ipairs(fs.getDirectoryItems("src/assets/texture")) do
        local file_name = get_file_name(v)
        _TEXTURE[file_name] = lg.newImage(f("src/assets/texture/%s", v))
        _TEXTURE[file_name]:setWrap("repeat")
    end

    _ASSET_SIZE = 16
    _RENDERED = 0

    _MOUSE_X, _MOUSE_Y = 0, 0 -- The mouse position of the Last frame

    g3d = require("src/class/g3d")
    map.init()

    state:load("game")
end

function save_config()
    ttf.save(config, "config.lua")
end

function clear_config()
    fs.remove("config.lua")
end

--The following are callback functions
function love.update(dt)
    keybind:trigger("keydown")
    state:update(dt)
    
end

function love.draw()
    _RENDERED = 0
    lg.setColor(1, 1, 1, 1)
    state:draw()
    if config.debug.enabled then
        local ent = "'_WORLD' is empty!"
        local look = g3d.camera.getDirectionPitch()
        look = (math.pi * 2) % look
        if _WORLD then ent = #_WORLD:getEntities() end
        local str = f("FPS: %d\nENTITIES:%s / %s\nCAMERA: %s", love.timer.getFPS(), tostring(_RENDERED) ,tostring(ent), tostring(look))
        lg.setColor(color(unpack(config.debug.text_color)))
        lg.printf(str, -12, 12, lg.getWidth(), "right")
    end
    _MOUSE_X, _MOUSE_Y = 0, 0
end

function love.keypressed(key)
    keybind:keypressed(key)
    keybind:trigger("keypressed", key)
    state:keypressed(key)
end

function love.textinput(t)
    state:textinput(t)
end

function love.keyreleased(key)
    keybind:trigger("keyreleased", key)
    keybind:keyreleased(key)
    state:keyreleased(key)
end

function love.mousepressed(x, y, key)
    state:mousepressed(x, y, key)
end

function love.mousereleased(x, y, key)
    state:mousereleased(x, y, key)
end

function love.mousemoved(x, y, dx, dy, touch)
    state:mousemoved(x, y, dx, dy, touch)
    _MOUSE_X, _MOUSE_Y = dx, dy
end

function love.wheelmoved(x, y)
    state:wheelmoved(x, y)
end

function love.quit()
    state:quit()
end
