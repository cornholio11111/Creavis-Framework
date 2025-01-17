local RunService = game:GetService("RunService")

local CreavisEngine = {
    VERSION = "v0.0.3";

    State = { -- >> Where booleans & enums are placed
        Studio = {
            InStudio = false,
            Running = false
        };


    };

    Mods = {}; -- >> Enabled mods are added into this array
    -- Mod Example: {Title:string, ModData:{}, Dependencies:{}}

    Dependencies = {Engine = {}, Mod = {}}; -- >> Packages that are needed for the mods to load
    -- Registered with one of 3 ids, "Engine", "Editor", "Mod", or "Plugin"
    -- Dependency Example: {Priority:Enum.ContextActionPriority, Title:string, ModuleData:{}}
    -- maybe also store the mod name or id smth about the mod in the dependency mods

    Utilities = {}; -- >> Utilities are premade packages that are used from 3rd party venders, example: knit
}
CreavisEngine.__index = CreavisEngine

-- // Base Engine

function CreavisEngine.Initialize()
    local self = setmetatable({}, CreavisEngine)
    if RunService:IsClient() then self.AuthoritySide = "client"
    elseif RunService:IsServer() then self.AuthoritySide = "server" end

    return self
end

function CreavisEngine:LoadEngineDependencies(Reloading:boolean?) -- << I like to load these
    Reloading = Reloading or #self.Dependencies.Engine > 0

    if Reloading then
        table.clear(self.Dependencies.Engine)
    end

    for __index, Object in pairs(script.Engine.Dependencies:GetChildren()) do
        local requiredObject = require(Object)
        self.Dependencies.Engine[Object.Name] = requiredObject
    end
end

function CreavisEngine:LoadTrainer(Trainer:ModuleScript|table?)
    if not Trainer then
        warn("Creavis Engine | Loading Default Trainer ('CreavisTrainer')")
        Trainer = require(script.CreavisTrainer)
    end

    
end

function CreavisEngine:LoadUI(Name)
    local UIData = self.Dependencies.Engine.RuGuiAdaptor.LoadModuleUI(Name, game.Players.LocalPlayer.PlayerGui, {Title = Name})

    return UIData
end

-- // Backend Engine

return CreavisEngine