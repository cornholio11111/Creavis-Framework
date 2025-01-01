-- // RuGuiCreateContext

--[[

    Holds the data on the User Interface

]]--

local RuGuiCreateContext = {}
RuGuiCreateContext.__index = RuGuiCreateContext

function RuGuiCreateContext.new(RuGuiData:{})
    local self = setmetatable({}, RuGuiCreateContext)

    self.RuGuiData = RuGuiData

    self.StyleSheet = {}

    self.Docks = {}
    self.Widgets = {}

    return self
end

-- // Configuration
local function ApplyStyle(Context, Object)
   local StyleSheetData = Context.StyleSheet
   local OBJStyle = StyleSheetData[string.lower(Object:GetAttribute("Type"))]

   if OBJStyle then
    for _index, value in pairs(OBJStyle) do
        if Object[_index] then
            Object[_index] = value
        end
    end
   end
end

function RuGuiCreateContext:SetStyleSheet(StyleSheetData:{})
    self.StyleSheet = StyleSheetData

    for __index, Dock in ipairs(self.Docks) do
        ApplyStyle(self, Dock)
        task.wait()
    end

    for __index, Widget in ipairs(self.Widgets) do
        ApplyStyle(self, Widget)
        task.wait()
    end
end

-- // Creating User Interface
function RuGuiCreateContext:CreateDockFrame(Title:string, Properties:{Position:UDim2, Size:UDim2})
    -- WindowScreenGui = self.WindowScreenGui,
    -- Width = self.Width,
    -- Height = self.Height,
    -- Title = self.Title,
    -- WindowBaseFrame= self.WindowBaseFrame

    local Dock = Instance.new("Frame", self.RuGuiData.WindowScreenGui.Docks)
    Dock.Name = Title
    Dock.ZIndex = #self.Docks + 1
    Dock.AnchorPoint = Vector2.new(.5, .5)

    Dock.BackgroundTransparency = 1

    Dock.Position = Properties.Position
    Dock.Size = Properties.Size

    Dock:SetAttribute("Dockable", true) -- << If something can dock to this DockFrame
    Dock:SetAttribute("Type", "Dock")

    self.Docks[string.lower(Title)] = Dock
    ApplyStyle(self, Dock)
    return {Dock = Dock, Index = Dock.ZIndex}
end

function RuGuiCreateContext:CreateWidget(Title:string, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, DockAt:string?)
    DockAt = DockAt or "None"
    Properties.StyleID = Properties.StyleID or "None"

    local Widget = Instance.new("Frame", self.RuGuiData.WindowScreenGui.Widgets)
    Widget.Name = Title
    Widget.ZIndex = #self.Widgets + 1
    Widget.AnchorPoint = Vector2.new(.5, .5)
    Widget:SetAttribute("Type", "Widget")
    Widget:SetAttribute("Style", Properties.StyleID)

    local DragHandle = Instance.new("Frame")
    DragHandle.Size = UDim2.new(1, 0, 0.1, 0) -- 10% of the widget's height
    DragHandle.AnchorPoint = Vector2.new(0.5, 0) -- Anchor at the top center
    DragHandle.Position = UDim2.new(0.5, 0, 0, 0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    DragHandle.Name = "DragHandle"
    DragHandle.Parent = Widget
    
    local DragDetector = Instance.new("UIDragDetector", Widget)
    DragDetector.Name = "DragDetector"
    DragDetector.ActivatedCursorIcon = ""
    DragDetector.CursorIcon = ""
    DragDetector.Enabled = false

    DragHandle.MouseEnter:Connect(function(x, y)
        DragDetector.Enabled = true
    end)

    DragHandle.MouseLeave:Connect(function(x, y)
        DragDetector.Enabled = false
    end)

    local DockReference = nil

    if DockAt == "None" then -- // Free
        Widget.Size = Properties.Size
        Widget.Position = Properties.Position


    elseif DockAt ~= "None" then -- // Docked
        DockReference = self.Docks[string.lower(DockAt)]

        if not DockReference then
            warn(DockAt.." wasn't found, check your spelling maybe?")
            error(self.Docks)
        end

        Widget.Position = DockReference.Position
        Widget.Size = DockReference.Size
    end
    

    Widget:SetAttribute("Docked", (DockAt ~= "None" and DockReference ~= nil))
    Widget:SetAttribute("DockedAt", DockAt)

    self.Widgets[string.lower(Title)] = Widget
    ApplyStyle(self, Widget)
    return {Widget = Widget, Index = Widget.ZIndex}
end

function RuGuiCreateContext:CreateFrame(Title, Properties:{ParentWidget:string, Position:UDim2, Size:UDim2, StyleID:string?})

end

function RuGuiCreateContext:Terminate()

end

-- // RuGui Core Code
local RuGui = {}
RuGui.Windows = {}

RuGui.States = {
    CurrentWindow = nil,
}

RuGui.__index = RuGui

function RuGui.CreateWindow(Width:number, Height:number, Title:string)
    local self = setmetatable({}, RuGui)
    self.Width = Width
    self.Height = Height
    self.Title = Title

    self.WindowScreenGui = Instance.new("ScreenGui")
    self.WindowScreenGui.Name = Title
    self.WindowScreenGui.IgnoreGuiInset = true

    self.DockFolder, self.WidgetFolder = Instance.new("Folder", self.WindowScreenGui), Instance.new("Folder", self.WindowScreenGui)
    self.DockFolder.Name = "Docks"
    self.WidgetFolder.Name = "Widgets"

    -- // creates the window base
    self.WindowBaseFrame = Instance.new("Frame", self.WindowScreenGui)
    self.WindowBaseFrame.BackgroundTransparency = 1
    self.WindowBaseFrame.AnchorPoint = Vector2.new(.5, .5)
    self.WindowBaseFrame.Position = UDim2.fromScale(.5, .5)
    self.WindowBaseFrame.Size = UDim2.fromScale(Width, Height)
    self.WindowBaseFrame.Name = "BaseFrame"

    -- // other properties
    self.Context = nil

    RuGui.Windows[Title] = self
    return self
end

function RuGui:CreateContext()
    if self.Context then
        self.Context:Terminate()
    end

    local RuGuiData = {
        WindowScreenGui = self.WindowScreenGui,
        Width = self.Width,
        Height = self.Height,
        Title = self.Title,
        WindowBaseFrame = self.WindowBaseFrame
    }

    self.Context = RuGuiCreateContext.new(RuGuiData)
    
end

-- // Removal
function RuGui:Terminate()
    
end

return RuGui