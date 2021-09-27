-- Special components:
-- _REMOVE: If an entity has the following component, Set to a truthy value, It will be removed.
-- _PROTECTED: If an entity has the following component, Set to a truthy value, It can't be removed.
-- _TYPE: The following component is a string containing the type of the entity. It's optional.
--        Can be used in filters if a certain system is only supposed to affect a certain type.
--        You can also just provide your own type component. ecs don't care

local ecs = {}
local ecs_meta = {__index = ecs}

-- Local methods
local remove = table.remove
local insert = table.insert
local fs = love.filesystem
local f = string.format

-- Helpers
-- This function can be used with newSystem & newEntity to load an entire folder of entities/systems at once
-- world:newSystem(ecs.loadFolder("src/entities"))
function ecs.loadFolder(directory)
    assert(fs.getInfo(directory), f("'%s' does not exist!", directory))
    assert(fs.getInfo(directory).type == "directory", f("'%s' is not a directory!", directory))
    local list = {}
    local items = fs.getDirectoryItems(directory)
    for _, file in ipairs(items) do
        insert(list, f("%s/%s", directory, file))
    end
    return unpack(list)
end

-- Creates and returns a whole new world
-- a world acts as a container for you systems & entities
function ecs.newWorld()
    local world = {
        systems = {},
        entities = {},
        callbacks = {}
    }

    return setmetatable(world, ecs_meta)
end
-- The functions below should be called on the world object.

-- Callback must be one of the following strings: 
local ALL_CALLBACK = {"onEntityAdd", "onEntityRemove"}
function ecs:registerCallback(callback, func)
    --assert(ALL_CALLBACK[callback] ~= nil, f("'%s' is not a valid callback", callback))
    self.callbacks[callback] = func
end

-- Adds a new system to the world.
-- Takes any number of arguments, Each can be either a table containing your system or
-- a path to a .lua file which returns a system
-- A system table needs to contain at least one method, "process"
-- Additionally it can have a filter method, Which decides what entities it processes.
-- Aside from that, Do whatever your little heart desires.
function ecs:newSystem(...)
    local list = {}
    for _, system in ipairs({...}) do
        if type(system) == "string" then
            local func, err = loadfile(system)
            if func then
                system = func()
            else
                error(f("Problem loading '%s': %s", system, err) )
            end
        end
        self.systems[#self.systems + 1] = system
        insert(list, self.systems[#self.systems])
    end

    if #list == 1 then
        return list[1]
    end
    return list
end

-- Adds an entity/entities to the world in the same fashion as newSystem.
-- Retruns a table with references to the added entities.
-- If only one entity is added, It will return it directly.
function ecs:newEntity(...)
    local list = {}
    for _, entity in ipairs({...}) do
        if type(entity) == "string" then
            local func, err = loadfile(entity)
            if func then
                entity = func()
            else
                error(f("Problem loading '%s': %s", entity, err) )
            end
        end
        entity.world = self
        self.entities[#self.entities + 1] = entity
        if self.callbacks["onEntityAdd"] then
            self.callbacks["onEntityAdd"](self.entities[#self.entities])
        end
        insert(list, self.entities[#self.entities])
    end
    if #list == 1 then
        return list[1]
    end
    return list
end

function ecs:removeEntity(index)
    local e = self.entities[index]
    remove(self.entities, index)
    if self.callbacks["onEntityRemove"] then
        self.callbacks["onEntityRemove"](e)
    end
end

-- Clears all entities
-- if remove_protected is true, Entities with the _PROTECTED flag will also be removed.
-- remove_protected defaults to false.
function ecs:clearEntities(remove_protected)
    remove_protected = remove_protected or false
    for i,entity in ipairs(self.entities) do
        if not entity._PROTECTED or remove_protected then
            self:removeEntity(i)
        end
    end
end

-- Returns a list of entities, Optionally filtered with a filter function
function ecs:getEntities(filter)
    filter = filter or function() return true end
    local list = {}
    for _, entity in ipairs(self.entities) do
        if filter(entity) then
            insert(list, entity)
        end
    end
    return list
end

-- Updates the world
function ecs:update(dt)
    dt = dt or 1
    for i,system in ipairs(self.systems) do
        for o, entity in ipairs(self.entities) do
            -- Removing entities with the _REMOVE flag
            if entity._REMOVE and not entity._PROTECTED then
                self:removeEntity(o)
            end
            if system.filter and system.filter(entity) then
                system.process(entity, dt)
            end
        end
    end
end

return ecs