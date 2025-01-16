local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreavisEngine = require(ReplicatedStorage.CreavisEngine)

local CreavisEngine = CreavisEngine.Initialize()
CreavisEngine:LoadEngineDependencies()

local RuGuiAdaptor = CreavisEngine.Dependencies.Engine.RuGuiAdaptor

CreavisEngine:ToggleStudio()

local StudioModuleData = RuGuiAdaptor.FindModule('Studio')

StudioModuleData.Context:SetStyleSheet(script.Parent.StyleSheet)
