local Players = game:GetService("Players")
local UserInterface = script.Parent.Parent.UserInterface
local StudioInterfaceModule, StudioStyleSheet = UserInterface:WaitForChild("Studio"), UserInterface:WaitForChild("StudioStyleSheet")

local Editor = {}
Editor.__index = Editor

Editor.Dependencies = {
    Freecam = require(script.FreecamModule);
    MovementTools = require(script.MovementTools);
}

function Editor.Initialize(CreavisEngine)
    local self = setmetatable({}, Editor)
    self.CreavisEngine = CreavisEngine

    self.EditorActive = false

    self:Connect()
    return self
end

function Editor:Connect()
    local RuGuiAdaptor = self.CreavisEngine.Dependencies.Engine.RuGuiAdaptor

    local StudioUI = RuGuiAdaptor.LoadModuleUI(StudioInterfaceModule, Players.LocalPlayer.PlayerGui, {Title = 'Studio'})
    StudioUI.Context:SetStyleSheet(require(StudioStyleSheet))

    task.wait()

    self.Dependencies.Freecam:EnableFreecam()
    self.Dependencies.MovementTools.Initialize(self)
end

return Editor