local RunService = game:GetService("RunService")
local BetterDebugging = require(script.Utility.BetterDebugging)

local CreavisFramework = {}
CreavisFramework.__index = CreavisFramework

CreavisFramework.Configurations = {
    MaxWorldSize_KB = 4000; -- 4 MB is the MAX SIZE
    MaxWorldsPerUser = -1; -- How many worlds, mods, or what ever can the user make? (-1 mean inf)

    Script_Editing = false;
    World_Editing = false;
    UI_Editing = false;
}

CreavisFramework.Dependencies = {} -- // Stores Dependencies data

local function AutoRequireDependencies(self)
    table.clear(self.Dependencies)

    for _index, rValue in pairs(script.Dependencies:GetChildren()) do
        if rValue:IsA("ModuleScript") and not self.Dependencies[rValue.Name] then
            local Module = require(rValue)

            if Module then
                if Module.Mode == "Any" then
                    self.Dependencies[rValue.Name] = Module

                    if Module.Initialize then
                        BetterDebugging.Print(1, rValue.Name .. " was initialized!")
                        Module.Initialize(self)
                    end
                elseif Module.Mode == self.Mode then
                    self.Dependencies[rValue.Name] = Module

                    if Module.Initialize then
                        BetterDebugging.Print(1, rValue.Name .. " was initialized!")
                        Module.Initialize(self)
                    end
                else
                    --BetterDebugging.Print(1, rValue.Name .. " was skipped due to mode mismatch (Expected: " .. self.Mode .. ", Got: " .. Module.Mode .. ")")
                end
            end
        end
    end
end

function CreavisFramework.new()
    local self = setmetatable({}, CreavisFramework)

    local isServer, isClient = RunService:IsServer(), RunService:IsClient()

    -- // General Info
    self.IsServer = isServer
    self.IsClient = isClient
    self.HasBegunPlay = false
    self.PlayerArray = {}

    if isServer then
        self.Mode = "Server"
    elseif isClient then
        self.Mode = "Client"
    end

    -- // Sets the Dependencies
    AutoRequireDependencies(self)

    -- // Sets the Systems

    self:InitGame()
    return self
end

function CreavisFramework:InitGame() --  This here will load everything
    
end

return CreavisFramework