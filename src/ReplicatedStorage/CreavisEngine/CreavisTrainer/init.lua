--[[
    This trainer should act like a DLL or a way to allow users too access your backend trainer for developing
    & containing mods.
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local UserInterface = script.UserInterface
local StudioInterfaceModule, StudioStyleSheet = UserInterface:WaitForChild("Studio"), UserInterface:WaitForChild("StudioStyleSheet")

local Trainer = {
    Name = "CreavisTrainer",

    References = {
        Player = nil, -- << Module Reference
        Editor = nil, -- << Module Reference
        
    },
}

Trainer.Dependencies = {}

function Trainer.Initialize(CreavisEngine)
    local self = setmetatable(Trainer, {})

    self.CreavisEngine = CreavisEngine
    self.Dependencies = CreavisEngine.Dependencies

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
    local RuGuiAdaptor = self.Dependencies.Engine.RuGuiAdaptor

    local StudioUI = RuGuiAdaptor.LoadModuleUI(StudioInterfaceModule, Players.LocalPlayer.PlayerGui, {Title = 'Studio'})
    StudioUI.Context:SetStyleSheet(require(StudioStyleSheet))

end

function Trainer:ConnectServer()
    local Server = self.Server

end

return Trainer