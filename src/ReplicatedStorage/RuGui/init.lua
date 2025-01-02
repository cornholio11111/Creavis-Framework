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
   local _Style = Object:GetAttribute("Style")
   if not _Style then return end
   local OBJStyle = StyleSheetData[string.lower(_Style)]

   if OBJStyle then
    for _index, value in pairs(OBJStyle) do
        if Object[_index] then
            Object[_index] = value
        end
    end
   end

   if #Object:GetChildren() > 0 then
    for index, ChildObject in pairs(Object:GetChildren()) do
        ApplyStyle(Context, ChildObject)
        task.wait(.001)
    end
   end
end

function RuGuiCreateContext:SetStyleSheet(StyleSheetData:{})
    self.StyleSheet = StyleSheetData

    for __index, Data in ipairs(self.Docks) do
        ApplyStyle(self, Data.Dock)
        task.wait()
    end

    for __index, Data in ipairs(self.Widgets) do
        ApplyStyle(self, Data.Widget)
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
    Dock.LayoutOrder = #self.Docks + 1
    Dock.AnchorPoint = Vector2.new(.5, .5)

    Dock.BackgroundTransparency = 1

    Dock.Position = Properties.Position
    Dock.Size = Properties.Size

    Dock:SetAttribute("Dockable", true) -- << If something can dock to this DockFrame
    Dock:SetAttribute("Type", "Dock")

    Dock:SetAttribute("Style", "Dock")

    self.Docks[string.lower(Title)] = Dock
    ApplyStyle(self, Dock)

    return {Dock = Dock, Index = Dock.LayoutOrder}
end

-- // Widgets are draggable its a cool system
function RuGuiCreateContext:CreateWidget(Title:string, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, DockAt:string?)
    DockAt = DockAt or "None"
    Properties.StyleID = Properties.StyleID or "None"

    local Widget = Instance.new("Frame", self.RuGuiData.WindowScreenGui.Widgets)
    Widget.Name = Title
    Widget.LayoutOrder = #self.Widgets + 1
    Widget.AnchorPoint = Vector2.new(.5, .5)
    Widget:SetAttribute("Type", "Widget")
    Widget:SetAttribute("Style", "Widget")

    local DragHandle = Instance.new("Frame")
    DragHandle.Size = UDim2.new(1, 0, 0.1, 0) -- 10% of the widget's height
    DragHandle.AnchorPoint = Vector2.new(0.5, 0) -- Anchor at the top center
    DragHandle.Position = UDim2.new(0.5, 0, 0, 0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    DragHandle.Name = "DragHandle"
    DragHandle.Parent = Widget
    DragHandle:SetAttribute("Type", "WidgetHeader")
    DragHandle:SetAttribute("Style", "WidgetHeader")
    
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

    self.Widgets[string.lower(Title)] = {Widget = Widget}
    ApplyStyle(self, DragHandle)
    ApplyStyle(self, Widget)
    return {Widget = Widget, Index = Widget.LayoutOrder}
end

-- // Frames get added into widgets
function RuGuiCreateContext:CreateFrame(Title, Properties:{ParentWidget:string, Position:UDim2, Size:UDim2, StyleID:string?}, WidgetID:string)
    WidgetID = WidgetID or "None"
    Properties.StyleID = Properties.StyleID or "None"

    if WidgetID == "None" then
        error("Widget Parent ID wasn't passed")
    elseif not self.Widgets[WidgetID] then
        error("Widget Not Found in self.Widgets in Rugui!")
    end

    local WidgetReference = self.Widgets[WidgetID]

    local Frame = Instance.new("Frame")
    Frame.Name = Title
    Frame.LayoutOrder = #WidgetReference:GetChildren() + 1
    Frame.AnchorPoint = Vector2.new(.5, .5)
    Frame:SetAttribute("Type", "UIFrame")
    Frame:SetAttribute("Style", "UIFrame")

    Frame.Position = Properties.Position
    Frame.Size = Properties.Size

    return {Frame = Frame, Index = Frame.LayoutOrder}
end

function RuGuiCreateContext:CreateMenu(Title:string, Properties:{UseListLayout:boolean?, SortOrder:Enum.SortOrder, Position:UDim2, Size:UDim2}, WidgetID:string)
    WidgetID = WidgetID or "None"
    Properties.StyleID = Properties.StyleID or "None"

    if WidgetID == "None" then
        error("Widget Parent ID wasn't passed")
    elseif not self.Widgets[WidgetID] then
        print(self.Widgets)
        error("Widget Not Found in self.Widgets in Rugui!")
    end

    local WidgetReference = self.Widgets[WidgetID]

    local Menu = Instance.new("Frame")
    Menu.Name = Title
    Menu.LayoutOrder = #WidgetReference:GetChildren() + 1
    Menu.AnchorPoint = Vector2.new(.5, .5)
    Menu:SetAttribute("Type", "UIMenu")
    Menu:SetAttribute("Style", "UIMenu")

    Menu.Position = Properties.Position
    Menu.Size = Properties.Size

    local SortLayout

    if Properties.UseListLayout == true then
        SortLayout = Instance.new("UIListLayout")
    else
        SortLayout = Instance.new("UIGridLayout")
    end

    SortLayout.Name = "Layout"
    SortLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder

    return {Menu = Menu, Index = Menu.LayoutOrder}
end

function RuGuiCreateContext:CreateHorizontalList(Title:string, Properties: {Position:UDim2, Size:UDim2, AutoAligned:boolean?, StyleID:string?}, ParentReference:UIBase)
    Properties.StyleID = Properties.StyleID or "HorizontalList"
    Properties.AutoAligned = Properties.AutoAligned or true

    local HorizontalList = Instance.new("Frame")
    HorizontalList.Name = Title

    HorizontalList.LayoutOrder = #ParentReference:GetChildren() + 1
    HorizontalList.AnchorPoint = Vector2.new(.5, .5)
    HorizontalList:SetAttribute("Type", "HorizontalList")
    HorizontalList:SetAttribute("Style", Properties.StyleID)

    if Properties.AutoAligned == false then 
        HorizontalList.Size = Properties.Size
        HorizontalList.Position = Properties.Position
    end

    HorizontalList.Parent = ParentReference
    return {List = HorizontalList, Index = HorizontalList.LayoutOrder}
end

function RuGuiCreateContext:CreateButton(Title:string, Properties: {Position:UDim2, Size:UDim2, Text:string?, IsImage:boolean?, Image:string?, StyleID:string?}, ParentReference:UIBase)
    local Button
    local _type

    Properties.StyleID = Properties.StyleID or "None"

    if Properties.IsImage then
        Button = Instance.new("ImageButton")
        Button.Image = Properties.Image
        _type = "ImageButton"
    else
        Button = Instance.new("TextButton")
        Button.Text = Properties.Text
        _type = "TextButton"
    end

    if Properties.StyleID == "None" then
        Properties.StyleID = _type
    end

    Button.Name = Title

    Button.LayoutOrder = #ParentReference:GetChildren() + 1
    Button.AnchorPoint = Vector2.new(.5, .5)
    Button:SetAttribute("Type", _type)
    Button:SetAttribute("Style", Properties.StyleID)

    if not Properties.AutoAligned then
        Button.Size = Properties.Size
        Button.Position = Properties.Position
    end

    Button.Parent = ParentReference
    return {Button = Button, Index = Button.LayoutOrder}
end

function RuGuiCreateContext:CreateToggle(Title:string, Properties: {Position:UDim2, Size:UDim2, Disabled:boolean?, Toggled:boolean?, Image:string?}, ParentReference:UIBase)

end

function RuGuiCreateContext:CreateTextbox(Title:string, Properties: {Position:UDim2, Size:UDim2, Text:string?, MultiLine:boolean?}, ParentReference:UIBase)

end

function RuGuiCreateContext:CreateLabel(Title:string, Properties: {Position:UDim2, Size:UDim2, Text:string?, IsImage:boolean?, Image:string?}, ParentReference:UIBase)

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