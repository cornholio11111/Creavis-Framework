local RunService = game:GetService("RunService")

local CreavisFramework = {}
CreavisFramework.__index = CreavisFramework

CreavisFramework.Configurations = {}
CreavisFramework.Dependencies = {} -- // Stores Dependencies data

CreavisFramework._Backend = { -- // No reason for anyone to really access this type of data
    Entities = {};
    Systems = {};

    Events = {}; -- EventHandler will populate this on EventHandler:TickUpdate() || MAYBE
    ChangeHistory = {};
};

local function AutoRequireDependencies(self) -- // When used it cleans the Dependencies Array and then populates it
    table.clear(self.Dependencies)

    for _index, rValue in pairs(script.Dependencies) do
        if rValue:IsA("Module") then
            local Module = require(rValue)

            if Module then
                -- // self.Dependencies[Module.Privacy or "Protected"]
                self.Dependencies[rValue.Name] = Module

                if Module.Initialize then
                    self.Dependencies[rValue.Name] = Module.Initialize()
                end
            end
        end
    end
end

function CreavisFramework.Initialize()
    local self = setmetatable({}, CreavisFramework)

    -- // General Info
    self.IsServer = RunService:IsServer()
    self.IsClient = RunService:IsClient()
    self.HasBegunPlay = false
    self.PlayerArray = {}

    -- // Sets the Dependencies
    AutoRequireDependencies(self)

    -- // Sets the Systems

    self:InitGame()
    return self
end

function CreavisFramework:InitGame() --  This here will load everything
    
end
