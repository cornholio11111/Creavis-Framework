--[[
    This trainer should act like a DLL or a way to allow users too access your backend trainer for developing
    & containing mods.
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Trainer = {
    Name = "CreavisTrainer",

    References = {
        Player = nil, -- << Module Reference
        Editor = require(script.Core.Editor), -- << Module Reference
        
    },
}
Trainer.__index = Trainer

Trainer.Dependencies = {}

function Trainer.Initialize(CreavisEngine)
    local self = setmetatable({}, Trainer)

    self.CreavisEngine = CreavisEngine
    self.Dependencies = CreavisEngine.Dependencies

    self.Client, self.Server = {}, {}

    if RunService:IsClient() then self.AuthoritySide = "client" self:ConnectClient()
    elseif RunService:IsServer() then self.AuthoritySide = "server" self:ConnectServer() end

    return self
end

function Trainer:Terminate()

end

-- // CONNECTIONS OF SHIZZ

function Trainer:ConnectClient()
    local Client = self.Client

    Client.Editor = self.References.Editor.Initialize(self) -- << Starts Editor
end

function Trainer:ConnectServer()
    local Server = self.Server

    Server.Editor = self.References.Editor.Initialize(self) -- << Starts Editor
end

return Trainer