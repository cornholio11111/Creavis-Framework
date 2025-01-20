local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
-- Change Tool

-- Input Handler

-- Mouse Handler

-- Selection Handler

local MovementTools = {}
MovementTools.__index = MovementTools

function MovementTools.Initialize(EdtiorReference)
    local self = setmetatable({}, MovementTools)
    self.EdtiorReference = EdtiorReference

    self.CurrentTool = "None"
    self.CurrentSelection = {}

    self:Connect()
    return self
end

function MovementTools:Connect()
    
end

function MovementTools:HandleMouseButtonClick(MouseButtonID:number) -- << Handle when mouse is clicked and detect if a object is selected
    if MouseButtonID == 1 then
        
    end

    if MouseButtonID == 2 then
        
    end
end

function MovementTools:ChangeTool(ToolID:string)
    ToolID = string.lower(ToolID)

    if ToolID == "move" then
        
    end
end

return MovementTools