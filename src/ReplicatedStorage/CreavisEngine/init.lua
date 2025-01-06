local RunService = game:GetService("RunService")
local CreavisEngine = {
    VERSION = "v0.0.1";

    State = { -- >> Where booleans & enums are placed
        Studio = {
            InStudio = false,
            Running = false
        };


    };

    Mods = {};
    Utilities = {};
}
CreavisEngine.__index = CreavisEngine

function CreavisEngine.Initialize()
    local self = setmetatable({}, CreavisEngine)
    if RunService:IsClient() then self.AuthoritySide = "client"
    elseif RunService:IsServer() then self.AuthoritySide = "server" end

    return self
end

function CreavisEngine:ToggleStudio()
    self.State.Studio.InStudio = not self.State.Studio.InStudio

    if self.State.Studio.InStudio then
        -- >> Load Studio
    end

    if not self.State.Studio.InStudio then
        -- >> Unload Studio
    end
end

return CreavisEngine