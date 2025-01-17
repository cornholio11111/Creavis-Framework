--[[
    This trainer should act like a DLL or a way to allow users too access your backend trainer for developing
    & containing mods.
]]--

local RunService = game:GetService("RunService")
local Trainer = {
    Name = "CreavisTrainer",

    References = {
        Player = nil, -- << Module Reference
        Editor = nil, -- << Module Reference
        
    },
}

Trainer.Dependencies = {}

function Trainer.Initialize()
    local self = setmetatable(Trainer, {})

    self.State = {
        ActiveEditor = false,
        DebuggingMode = true,
    }

    self.Client, self.Server = {}, {}

    if RunService:IsClient() then self.AuthoritySide = "client" self:ConnectClient()
    elseif RunService:IsServer() then self.AuthoritySide = "server" self:ConnectServer() end

    return self
end

function Trainer:ConnectClient()
    local Client = self.Client

end

function Trainer:ConnectServer()
    local Server = self.Server

end

return Trainer