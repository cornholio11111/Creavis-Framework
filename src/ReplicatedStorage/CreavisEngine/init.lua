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

    Dependencies = {Engine = {}, Mod = {}, Plugin = {}}; -- >> Packages that are needed for the mods to load
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
    if self.Trainer ~= nil then
        self.Trainer:Terminate()
    end

    if not Trainer then
        warn("Creavis Engine | Loading Default Trainer...")
        Trainer = require(script.CreavisTrainer)
    end

    local TrainerContext = {}
    TrainerContext.Trainer = Trainer

    if not TrainerContext.Trainer.Initialize then
        error("Loaded Trainer Doesn't have a .Initialize(CreavisEngine) function, please add on to handle the Trainer propertly")
    end

    TrainerContext.Trainer.Initialize(self) -- << Starts the Trainer, passes 'self' for the trainer to work with my engine

    self.Trainer = TrainerContext

    return TrainerContext
end

return CreavisEngine