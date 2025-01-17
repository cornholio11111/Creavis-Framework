local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreavisEngine = require(ReplicatedStorage.CreavisEngine)

local CreavisEngine = CreavisEngine.Initialize()
CreavisEngine:LoadEngineDependencies()

local StudioData = CreavisEngine:LoadUI('Studio')
StudioData.Context:SetStyleSheet(require(script.Parent.StyleSheet))
