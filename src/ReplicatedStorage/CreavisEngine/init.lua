local RunService = game:GetService("RunService")

local CreavisEngine = {
    VERSION = "v0.0.1";

    State = { -- >> Where booleans & enums are placed
        Studio = {
            InStudio = false,
            Running = false
        };


    };
    

    Mods = {}; -- >> Enabled mods are added into this array
    -- Mod Example: {Title:string, ModData:{}, Dependencies:{}}

    Dependencies = {Engine = {}, Mod = {}}; -- >> Packages that are needed for the mods to load
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

    self.studioToggled = false

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

function CreavisEngine:ToggleStudio(Boolean:boolean)
    Boolean = Boolean or not self.Dependencies.Engine.RuGuiAdaptor

    local StudioData = self.Dependencies.Engine.RuGuiAdaptor.LoadModuleUI('Studio', game.Players.LocalPlayer.PlayerGui, {Title = 'Studio'})
end

function CreavisEngine:LoadModDependencies(Modpack:ModuleScript)
    
end

-- // Backend Engine

return CreavisEngine