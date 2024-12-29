--[[

R - Roblox
U - Universal
G - Graphical
UI - User Interface

]]--

local RuGui = {}
RuGui.__index = RuGui


function RuGui.Initialize(CreavisFramework)
    local self = setmetatable({}, RuGui)
    self.CreavisFrameworkReference = CreavisFramework

    self.Screen = {}

    return self
end


function RuGui:Connect()
    
end


return RuGui
