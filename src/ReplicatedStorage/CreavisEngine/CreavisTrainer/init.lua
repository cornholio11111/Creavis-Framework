--[[
    This trainer should act like a DLL or a way to allow users too access your backend trainer for developing
    & containing mods.
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Trainer = {
    Name = "CreavisTrainer",

    References = {
        Player = require(script.Core.Player), -- << Module Reference
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

    self.TrainerFolder = workspace:FindFirstChild("Trainer") or Instance.new("Folder", workspace)
    self.TrainerFolder.Name = "Trainer"

    self.ClientFolder, self.ServerFolder = self.TrainerFolder:FindFirstChild("Client") or Instance.new("Folder", self.TrainerFolder), self.TrainerFolder:FindFirstChild("Server") or Instance.new("Folder", self.TrainerFolder)
    self.ClientFolder.Name = "Client"
    self.ServerFolder.Name = "Server"

    if RunService:IsClient() then self.AuthoritySide = "client" self:ConnectClient()
    elseif RunService:IsServer() then self.AuthoritySide = "server" self:ConnectServer() end

    return self
end

function Trainer:Terminate()

end

-- // CONNECTIONS OF SHIZZ


function Trainer:ConnectClient()
    local Client = self.Client

    Client.Player = self.References.Player.Initialize(self) -- << Starts the Player for mod using
    Client.Editor = self.References.Editor.Initialize(self) -- << Starts Editor
end

function Trainer:ConnectServer()
    local Server = self.Server

    Server.Player = self.References.Player.Initialize(self) -- << Starts the Player for mod using
    Server.Editor = self.References.Editor.Initialize(self) -- << Starts Editor
end

return Trainer