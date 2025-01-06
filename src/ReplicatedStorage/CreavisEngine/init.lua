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
 
    require(script.Engine.Dependencies.RuGuiAdaptor).LoadModuleUI('Studio', game.Players.LocalPlayer.PlayerGui, {})

    return self
end

function CreavisEngine:LoadEngineDependencies()
    
end

function CreavisEngine:LoadModDependencies(Modpack:ModuleScript)
    
end

-- // Backend Engine

return CreavisEngine