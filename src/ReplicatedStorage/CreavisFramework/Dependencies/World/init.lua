--[[

    World is a "Level" which stores data, data linked to PROPS & SCRIPTS which the player added.

    Acts similar to Unreal Engine Gamemode

]]--

local World = {}
World.__index = World

-- The CreavisFramework:InitGame event is called before any other scripts (including 'PreInitializeComponents'), and is used by 
-- AGameModeBase to initialize parameters and spawn its helper classes.

-- This is called before any Actor runs 'PreInitializeComponents', including the Game Mode instance itself.

function World.Initialize(CreavisFramework)
    local self = setmetatable({}, World)
    self.CreavisFrameworkReference = CreavisFramework

    return self
end

return World