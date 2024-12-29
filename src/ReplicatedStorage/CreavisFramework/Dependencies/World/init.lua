local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")

local EventHandler = require(script.Parent.EventHandler)

--[[

    World is a "Level" which stores data, data linked to PROPS & SCRIPTS which the player added.

    Acts similar to Unreal Engine Gamemode

]]--

local World = {}
World.Mode = "Any"
World.__index = World

-- The CreavisFramework:InitGame event is called before any other scripts (including 'PreInitializeComponents'), 
-- and is used by WorldHelper to initialize parameters and spawn its helper classes.

-- This is called before any Actor runs 'PreInitializeComponents', including the Game Mode instance itself.

function World.Initialize(CreavisFramework)
    local self = setmetatable({}, World)
    self.CreavisFrameworkReference = CreavisFramework

    self.Components = {}

    -- // A component is just a "system" that is coded in OOP or ECS using EngineCS

    self.Workshop = {
        ReplicatedStorage = ReplicatedStorage;
        ServerScriptService = ServerScriptService;
        ServerStorage = ServerStorage;
        StarterPlayer = StarterPlayer;
        StarterGui = StarterGui;
    }

    self:InitWorld()
    return self
end

function World:InitWorld()
    
end

function World:PreInitializeComponents()
    
end

return World