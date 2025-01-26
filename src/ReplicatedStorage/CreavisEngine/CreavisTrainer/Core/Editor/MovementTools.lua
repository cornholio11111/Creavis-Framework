-- Change Tool

-- Input Handler

-- Mouse Handler

-- Selection Handler

local MovementTools = {}
MovementTools.__index = MovementTools

function MovementTools.Initialize(EditorReference)
    local self = setmetatable({}, MovementTools)
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