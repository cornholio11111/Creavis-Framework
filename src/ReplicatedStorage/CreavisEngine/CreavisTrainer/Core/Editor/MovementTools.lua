local MovementTools = {}

MovementTools.Dependencies = {}

function MovementTools.Initialize(CreavisEngine)
    local self = setmetatable(MovementTools, {})
    self.CreavisEngine = CreavisEngine

    self.SelectedTool = "select"
    --[[
        Tools:
    
        'Select'
        'Move'
        'Size'
        'Rotate'
        'Transform'
    ]]--

    self:Connect()
    return self
end

function MovementTools:Connect()

end

function MovementTools:SwapTool(ToolID)
    self.SelectedTool = string.lower(ToolID)
end

-- Swap tools

-- movement tools

-- resize tools

-- rotate tools

-- bounding box

-- hover over highlight

return MovementTools