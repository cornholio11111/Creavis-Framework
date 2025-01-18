local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
-- // RuGuiCreateContext

--[[

    Holds the data on the User Interface

]]--

--[[
    TODO:

    - add dock stacking of widgets
    - add toolbar dropdowns

]]--

local RuGuiCreateContext = {}
RuGuiCreateContext.__index = RuGuiCreateContext

function RuGuiCreateContext.new(RuGuiData:{})
    local self = setmetatable({}, RuGuiCreateContext)

    self.RuGuiData = RuGuiData

    self.StyleSheet = {}
    self.Connections = {}

    self.Docks = {}
    self.Widgets = {}

    self.Objects = {}

    self.DockInfo = {} -- << Whats widgets are docked where and what stack order

    self.CurrentDraggedWidget = nil
    self.LastDraggedWidget = nil

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
    if typeof(StyleSheetData) == "Instance" then
        if StyleSheetData:IsA("ModuleScript") then
            StyleSheetData = require(StyleSheetData)
        end
    end

    self.StyleSheet = StyleSheetData

    for __index, Data in pairs(self.Docks) do
        ApplyStyle(self, Data)
        task.wait()
    end

    for __index, Data in pairs(self.Widgets) do
        ApplyStyle(self, Data)
        task.wait()
    end
end

--#region

function RuGuiCreateContext:DockWidget(Widget:string, Dock:string)
    local DockReference = self.Docks[string.lower(Dock)]
    local WidgetReference = self.Widgets[string.lower(Widget)]
    
    if WidgetReference then
        if DockReference then
            -- DOCK THE FRAME!!
            WidgetReference.Position = DockReference.Position
            WidgetReference.Size = DockReference.Size
            ApplyStyle(self, WidgetReference)
        else
            error(Dock.." can't be found in self.Docks!")
        end
    else
        error(Widget.." can't be found in self.Widgets!")
    end
end


-- // local functionality

local function IsNearDock(dock, margin)
    local Mouse = Players.LocalPlayer:GetMouse()
    local Frame = dock

    return Mouse.X > Frame.AbsolutePosition.X and Mouse.X < Frame.AbsolutePosition.X + Frame.AbsoluteSize.X and Mouse.Y > Frame.AbsolutePosition.Y and Mouse.Y < Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
end


--#endregion

--#region User Interface Creation

-- // Creating User Interface
function RuGuiCreateContext:CreateDockFrame(Title:string, Properties:{Position:UDim2, Size:UDim2, Dockable:boolean?})
    local Dock = Instance.new("Frame", self.RuGuiData.WindowBaseFrame.Docks)
    Dock.Name = Title
    Dock.LayoutOrder = #self.Docks + 1
    Dock.AnchorPoint = Vector2.new(.5, .5)

    Dock.BackgroundTransparency = 1

    Dock.Position = Properties.Position
    Dock.Size = Properties.Size

    Dock:SetAttribute("Dockable", Properties.Dockable) -- << If something can dock to this DockFrame
    Dock:SetAttribute("Type", "Dock")

    Dock:SetAttribute("Style", "Dock")

    self.Docks[string.lower(Title)] = Dock
    self.DockInfo[string.lower(Title)] = {}

    self.Objects[string.lower(Title)] = Dock
    ApplyStyle(self, Dock)

    return {Dock = Dock, Index = Dock.LayoutOrder}
end

-- // Widgets are draggable its a cool system
function RuGuiCreateContext:CreateWidget(Title:string, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, DockAt:string?)
    DockAt = DockAt or "None"
    Properties.StyleID = Properties.StyleID or "None"

    local Widget = Instance.new("Frame", self.RuGuiData.WindowBaseFrame.Widgets)
    Widget.Name = Title
    Widget.LayoutOrder = #self.Widgets + 1
    Widget.ZIndex = #self.Widgets + 1
    Widget.AnchorPoint = Vector2.new(.5, .5)
    Widget:SetAttribute("Type", "Widget")
    Widget:SetAttribute("Style", "Widget")
    Widget:SetAttribute("D_Index", Widget.ZIndex)

    local DragHandle = Instance.new("Frame")
    DragHandle.Size = UDim2.new(1, 0, 0, 10)
    DragHandle.AnchorPoint = Vector2.new(0.5, 0)
    DragHandle.Position = UDim2.new(0.5, 0, 0, 0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    DragHandle.Name = "DragHandle"
    DragHandle.ZIndex = 2
    DragHandle.LayoutOrder = 2
    DragHandle.Parent = Widget
    DragHandle:SetAttribute("Type", "WidgetHeader")
    DragHandle:SetAttribute("Style", "WidgetHeader")

    local UIGradient = Instance.new("UIGradient", DragHandle)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40)),
    })
    UIGradient.Rotation = 90

    -- Header label (Title)
    local Label = Instance.new("TextLabel")
    Label.Name = "Title"
    Label.Size = UDim2.new(0.8, 0, .8, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0) -- Slight left margin
    Label.BackgroundTransparency = 1
    Label.Text = Title
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.Parent = DragHandle
    Label:SetAttribute("Type", "WidgetHeaderText")
    Label:SetAttribute("Style", "WidgetHeaderText")

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 10, 0, 10)
    CloseButton.AnchorPoint = Vector2.new(1, .5)
    CloseButton.Position = UDim2.new(1, 0, .5, 0) -- Right-aligned
    CloseButton.BackgroundTransparency = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 85, 85)
    CloseButton.TextScaled = true
    CloseButton.Font = Enum.Font.GothamMedium
    CloseButton.TextXAlignment = Enum.TextXAlignment.Center
    CloseButton.Parent = DragHandle
    CloseButton:SetAttribute("Type", "WidgetHeaderExit")
    CloseButton:SetAttribute("Style", "WidgetHeaderExit")

    local UICornerClose = Instance.new("UICorner", CloseButton)
    UICornerClose.CornerRadius = UDim.new(1, 0)

    local DragDetector = Instance.new("UIDragDetector", Widget)
    DragDetector.Name = "DragDetector"
    DragDetector.ActivatedCursorIcon = ""
    DragDetector.CursorIcon = ""
    DragDetector.Enabled = false

    local CanEditDragDetector = true
    local IsDragging = false
    local wannaDock = nil

    CloseButton.MouseButton1Click:Connect(function()
        Widget:SetAttribute("Active", false)
        Widget.Visible = false
    end)

    local function BringToFront(widget)
        for _, w in pairs(self.Widgets) do
            w.ZIndex = w:GetAttribute("D_Index")
        end
        widget.ZIndex = 100
    end

    DragDetector.DragStart:Connect(function()
        IsDragging = true
        CanEditDragDetector = false
        BringToFront(Widget)
        self.CurrentDraggedWidget = Title

        if not self.Connections["DragRenderStepped"..Title] then
            self.Connections["DragRenderStepped"..Title] = RunService:BindToRenderStep("DragRenderStepped"..Title, 0, function()
                if IsDragging then
                    for _, dock in pairs(self.Docks) do
                        if dock:GetAttribute("Dockable") and IsNearDock(dock, 15) then
                            wannaDock = dock

                            dock.BackgroundColor3 = Color3.fromRGB(0, 0, 225)
                            dock.BackgroundTransparency = .5

                        else
                            if wannaDock == dock then
                                wannaDock = nil
                            end
                            ApplyStyle(self, dock)
                        end

                        task.wait()
                    end
                end
            end)
        end
    end)

    DragDetector.DragEnd:Connect(function()
        IsDragging = false
        CanEditDragDetector = true

        RunService:UnbindFromRenderStep("DragRenderStepped"..Title)

        if wannaDock ~= nil then
            ApplyStyle(self, wannaDock)
            self:DockWidget(Title, wannaDock.Name)
        end

        self.LastDraggedWidget = Title
    end)

    DragHandle.MouseEnter:Connect(function()
        if CanEditDragDetector then
            DragDetector.Enabled = true
        end
    end)

    DragHandle.MouseLeave:Connect(function()
        if CanEditDragDetector then
            DragDetector.Enabled = false
        end
    end)

    local DockReference = nil

    if DockAt == "None" then
        Widget.Size = Properties.Size
        Widget.Position = Properties.Position
    else
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
    self.Objects[string.lower(Title)] = Widget
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
    elseif not self.Widgets[string.lower(WidgetID)] then
        error("Widget Not Found in self.Widgets in Rugui!")
    end

    local WidgetReference = self.Widgets[string.lower(WidgetID)]

    local Frame = Instance.new("Frame")
    Frame.Name = Title
    Frame.LayoutOrder = #WidgetReference:GetChildren() + 1
    Frame.AnchorPoint = Vector2.new(.5, .5)
    Frame:SetAttribute("Type", "UIFrame")
    Frame:SetAttribute("Style", "UIFrame")

    Frame.Position = Properties.Position
    Frame.Size = Properties.Size

    self.Objects[string.lower(Title)] = Frame
    ApplyStyle(self, Frame)
    return {Frame = Frame, Index = Frame.LayoutOrder}
end

function RuGuiCreateContext:CreateScrollMenu(Title:string, Properties:{UseListLayout:boolean?, UseGridLayout:boolean?, LayoutPadding:UDim2?, SortOrder:Enum.SortOrder?, Position:UDim2, Size:UDim2}, ParentID:string)
    ParentID = ParentID or "None"
    Properties.StyleID = Properties.StyleID or "None"

    if Properties.UseGridLayout or Properties.UseListLayout then
        Properties.UIPadding = Properties.UIPadding or UDim.new(.25, 0)
        Properties.CellPadding = Properties.CellPadding or UDim2.new(.25, 0, .25, 0)
    end

    if ParentID == "None" then
        error("Widget Parent ID wasn't passed")
    elseif not self.Objects[string.lower(ParentID)] then
        print(self.Objects)
        error(ParentID.." Not Found in self.Objects in Rugui!")
    end

    local ParentReference = self.Objects[string.lower(ParentID)]

    local ScrollingFrame = Instance.new("ScrollingFrame", ParentReference)
    ScrollingFrame.Name = Title
    ScrollingFrame.LayoutOrder = #ParentReference:GetChildren() + 1
    ScrollingFrame.AnchorPoint = Vector2.new(.5, .5)
    ScrollingFrame:SetAttribute("Type", "ScrollFrame")
    ScrollingFrame:SetAttribute("Style", "ScrollFrame")
    
    if Properties.UseListLayout then
        local ListLayout = Instance.new("UIListLayout", ScrollingFrame)
        ListLayout.Padding = Properties.LayoutPadding
        ListLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder
    elseif Properties.UseGridLayout then
        local GridLayout = Instance.new("UIGridLayout", ScrollingFrame)
        GridLayout.CellPadding = Properties.LayoutPadding
        GridLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder
    end

    return {Menu = ScrollingFrame, Index = ScrollingFrame.LayoutOrder}
end

function RuGuiCreateContext:CreateMenu(Title:string, Properties:{UseListLayout:boolean?, UIPadding:UDim?, CellPadding:UDim2?, SortOrder:Enum.SortOrder?, Position:UDim2, Size:UDim2}, WidgetID:string)
    WidgetID = WidgetID or "None"
    Properties.StyleID = Properties.StyleID or "None"
    Properties.UIPadding = Properties.UIPadding or UDim.new(.25, 0)
    Properties.CellPadding = Properties.CellPadding or UDim2.new(.25, 0, .25, 0)

    if WidgetID == "None" then
        error("Widget Parent ID wasn't passed")
    elseif not self.Widgets[string.lower(WidgetID)] then
        print(self.Widgets)
        error("Widget Not Found in self.Widgets in Rugui!")
    end

    local WidgetReference = self.Widgets[string.lower(WidgetID)]

    local Menu = Instance.new("Frame", WidgetReference)
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

        SortLayout.Padding = Properties.UIPadding
    else
        SortLayout = Instance.new("UIGridLayout")

        SortLayout.CellPadding = Properties.CellPadding
    end

    SortLayout.Name = "Layout"
    SortLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder
    self.Objects[string.lower(Title)] = Menu
    ApplyStyle(self, SortLayout)
    return {Menu = Menu, Index = Menu.LayoutOrder}
end

function RuGuiCreateContext:CreateList(Title:string, Properties: {Position:UDim2?, FillDirection:Enum.FillDirection?, Size:UDim2?, AutoAligned:boolean?, UIPadding:UDim?, StyleID:string?}, ParentReference)
    Properties.StyleID = Properties.StyleID or "HorizontalList"
    Properties.UIPadding = Properties.UIPadding or UDim.new(.25, 0)

    local HorizontalList = Instance.new("Frame")
    HorizontalList.Name = Title

    HorizontalList.LayoutOrder = #ParentReference:GetChildren() + 1
    HorizontalList.AnchorPoint = Vector2.new(.5, .5)
    HorizontalList:SetAttribute("Type", "HorizontalList")
    HorizontalList:SetAttribute("Style", Properties.StyleID)

    local UIListLayout = Instance.new("UIListLayout", HorizontalList)
    UIListLayout.FillDirection = Properties.FillDirection
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = Properties.UIPadding

    if not Properties.AutoAligned then
        HorizontalList.Size = Properties.Size
        HorizontalList.Position = Properties.Position
    end

    self.Objects[string.lower(Title)] = HorizontalList
    ApplyStyle(self, HorizontalList)
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

    local LOrder = #ParentReference:GetChildren()
    if LOrder > 0 then
        LOrder += 1
    end

    Button.LayoutOrder = LOrder
    Button.AnchorPoint = Vector2.new(.5, .5)
    Button.Size = Properties.Size or UDim2.fromScale(.2, .2)
    Button.Position = Properties.Position
    
    Button:SetAttribute("Type", _type)
    Button:SetAttribute("Style", Properties.StyleID)

    self.Objects[string.lower(Title)] = Button
    ApplyStyle(self, Button)
    Button.Parent = ParentReference
    return {Button = Button, Index = Button.LayoutOrder}
end

function RuGuiCreateContext:CreateDropdown(Title:string, Properties: { Position: UDim2, Size: UDim2, Text: string?, IsImage: boolean?, Image: string?}, ParentReference: UIBase)
    if not ParentReference then error("Parent reference is required to create a dropdown.") end

    local DropdownContext = {}

    DropdownContext.MainButton = self:CreateButton(Title, {
        Position = Properties.Position,
        Size = Properties.Size,
        Text = Properties.Text,
        IsImage = Properties.IsImage or false,
        Image = Properties.Image
    }, ParentReference)

    DropdownContext.DropdownBox = self:CreateList(Title.."List", {
        Position = UDim2.new(
            Properties.Position.X.Scale,
            Properties.Position.X.Offset,
            Properties.Position.Y.Scale,
            Properties.Position.Y.Offset + Properties.Size.Y.Offset
        ),

        Size = UDim2.new(Properties.Size.X.Scale, Properties.Size.X.Offset, 0, 100)
    }, ParentReference)

    DropdownContext.MainButton.MouseButton1Click:Connect(function()
        DropdownContext.DropdownBox.Visible = not DropdownContext.DropdownBox.Visible
    end)

    function DropdownContext:AddOption(Text, MouseButton1Click_Callback)
        local OptionButton = self:CreateButton(Text, {
            Position = UDim2.new(0, 0, 0, #DropdownContext.DropdownBox:GetChildren() * 30),
            Size = UDim2.new(1, 0, 0, 30),
            Text = Text
        }, DropdownContext.DropdownBox)

        OptionButton.MouseButton1Click:Connect(function()
            if MouseButton1Click_Callback then
                MouseButton1Click_Callback()
            end

            DropdownContext.DropdownBox.Visible = false
        end)
    end

    return DropdownContext
end

function RuGuiCreateContext:CreateLabel(Title: string, Properties: { Position: UDim2, Size: UDim2, Text: string?, IsImage: boolean?, Image: string?, Editable: boolean? }, ParentReference: UIBase)
    if not ParentReference then error("Parent reference is required to create a label.") end

    local Label
    if Properties.IsImage then
        Label = Instance.new("ImageLabel", ParentReference)
        Label.Image = Properties.Image or ""
        Label.ScaleType = Enum.ScaleType.Fit
        Label.BackgroundTransparency = 1
    elseif Properties.Editable then
        Label = Instance.new("TextBox", ParentReference)
        Label.Text = Properties.Text or ""
        Label.ClearTextOnFocus = false
        Label.TextEditable = true
    else
        Label = Instance.new("TextLabel", ParentReference)
        Label.Text = Properties.Text or ""
    end

    Label.Name = Title
    Label.Position = Properties.Position
    Label.Size = Properties.Size
    Label.LayoutOrder = #ParentReference:GetChildren() + 1
    Label.AnchorPoint = Vector2.new(0.5, 0.5)
    Label.TextScaled = true
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundColor3 = Color3.new(0, 0, 0)
    Label.BackgroundTransparency = 0.5

    if Properties.IsImage then
        Label.SizeConstraint = Enum.SizeConstraint.RelativeXY
    elseif Properties.Editable then
        Label.PlaceholderText = "Enter text here..."
        Label.TextWrapped = true
    else
        Label.TextWrapped = true
    end

    return {Label = Label, Index = Label.LayoutOrder}
end

--#endregion

function RuGuiCreateContext:Terminate() 
    -->> Any clean up may needed should be added here
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
    self.WindowScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.WindowScreenGui.ClipToDeviceSafeArea = true

    -- // creates the window base
    self.WindowBaseFrame = Instance.new("Frame", self.WindowScreenGui)
    self.WindowBaseFrame.BackgroundTransparency = 1
    self.WindowBaseFrame.AnchorPoint = Vector2.new(.5, .5)
    self.WindowBaseFrame.Position = UDim2.fromScale(.5, .5)
    self.WindowBaseFrame.Size = UDim2.fromScale(Width, Height)
    self.WindowBaseFrame.Name = "BaseFrame"

    self.DockFolder, self.WidgetFolder = Instance.new("Folder", self.WindowBaseFrame), Instance.new("Folder", self.WindowBaseFrame)
    self.DockFolder.Name = "Docks"
    self.WidgetFolder.Name = "Widgets"

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
    self.WindowScreenGui:Destory()

    self.Context:Terminate()
end

return RuGui