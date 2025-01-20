-- Change Tool

-- Input Handler

-- Mouse Handler

-- Selection Handler

local MovementTools = {}
MovementTools.__index = MovementTools

function MovementTools.Initialize(EdtiorReference)
    local self = setmetatable({}, MovementTools)
    self.EdtiorReference = EdtiorReference

    self.SelectionContext = self:CreateSelectionContext()

    self.SelectionContext.Initialize() -- << Starts the Selection Functionality

    self.CurrentTool = "None"
    self.CurrentSelection = {}

    return self
end

function MovementTools:CreateSelectionContext()
    local SelectionContext = {}
    self.MovementToolReference = MovementTools

    function SelectionContext.Initialize()
        
    end

    return SelectionContext
end

function MovementTools:ChangeTool(ToolID:string)
    ToolID = string.lower(ToolID)

    if ToolID == "move" then
        
    end
end

return MovementTools