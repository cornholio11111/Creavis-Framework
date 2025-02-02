-- Change Tool

-- Input Handler

-- Mouse Handler

-- Selection Handler
local InputHandler = require(script.Parent.InputHandler)

local StudioTools = {}
StudioTools.__index = StudioTools

function StudioTools.Initialize(EditorReference)
    local self = setmetatable({}, StudioTools)
    self.EditorReference = EditorReference

    self.CurrentTool = "None"
    self.CurrentSelection = {}

    local ToolFolder = Instance.new("Folder", workspace:WaitForChild("Trainer"):WaitForChild("Client"))
    ToolFolder.Name = "Tools"

    self.ToolInstances = {
        Arcs = Instance.new("ArcHandles", ToolFolder);
        Handles = Instance.new("Handles", ToolFolder);
    }

    self:Connect()
    return self
end

function StudioTools:Connect()
    InputHandler:BindKey(Enum.UserInputType.MouseButton1, function() -- << Left Click
        
    end)

    InputHandler:BindKey(Enum.UserInputType.MouseButton2, function() -- << Right Click
        
    end)
end

function StudioTools:ChangeTool(ToolID:string)
    ToolID = string.lower(ToolID)

    if ToolID == "move" then
        
    end
end

return StudioTools