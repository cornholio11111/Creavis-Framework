local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
-- // RuGuiCreateContext

--[[

    Holds the data on the User Interface

]]--

--[[
    TODO:

    - add dock stacking of widgets
    - add toolbar dropdowns

    - fix the slowness on this framework

]]--

local ComponentsFolder = script.Components
local BaseComponentsFolder = ComponentsFolder.Base

local RequiredComponents = {
    DockFrame = require(BaseComponentsFolder.Dock);
    Widget = require(BaseComponentsFolder.Widget);
    Frame = require(BaseComponentsFolder.Frame);
    List = require(BaseComponentsFolder.List);
    Menu = require(BaseComponentsFolder.Menu);
    ScrollMenu = require(BaseComponentsFolder.ScrollMenu);
    Button = require(BaseComponentsFolder.Button);
    Label = require(BaseComponentsFolder.Label);

    Dropdown = require(ComponentsFolder.Dropdown);
    TabList = require(ComponentsFolder.TabList);
}

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

function RuGuiCreateContext.ApplyStyle(Context, Object)
    ApplyStyle(Context, Object)
end

function RuGuiCreateContext:SetStyleSheet(StyleSheetData:{})
    if typeof(StyleSheetData) == "Instance" then
        if StyleSheetData:IsA("ModuleScript") then
            StyleSheetData = require(StyleSheetData)
        end
    end

    self.StyleSheet = StyleSheetData

    for __index, Data in pairs(self.Docks) do
        ApplyStyle(self, Data.Dock)
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
            print(DockReference)
            local _Dock = DockReference.Dock
            local DockWidgets = DockReference.Data.Widgets

            local OLDDOCKID = nil

            if WidgetReference:GetAttribute("DockID") ~= 'nil' then
                OLDDOCKID = WidgetReference:GetAttribute("DockID")
                local OLDDockReference = self.Docks[string.lower(OLDDOCKID)]
                local OLDDock = OLDDockReference.Dock
                local OLDDockWidgets = OLDDockReference.Data.Widgets
                
                OLDDockWidgets[Widget] = nil
            end


            WidgetReference:SetAttribute("DockID", Dock)
            DockWidgets[Widget] = {LayoutOrder = #DockWidgets, Selected = true}

            -- << Added docking with multiple UI, now need to add some sort of updater for this...
            self:DockUpdated(Dock)
            if OLDDOCKID then self:DockUpdated(OLDDOCKID) end

            -- DOCK THE FRAME!!
            WidgetReference.Position = _Dock.Position
            WidgetReference.Size = _Dock.Size
            ApplyStyle(self, WidgetReference)
        else
            error(Dock.." can't be found in self.Docks!")
        end
    else
        error(Widget.." can't be found in self.Widgets!")
    end
end

function RuGuiCreateContext:DockUpdated(Dock:string)
    local DockReference = self.Docks[string.lower(Dock)]

    -- local Tablist = self:CreateTabList(Dock.."Tablist", {Position = UDim2.new(), Size = UDim2.new()}, DockReference.Dock)
   --<<  
end


-- // local functionality

local function IsNearDock(dock, margin)
    local Mouse = Players.LocalPlayer:GetMouse()
    local Frame = dock

    return Mouse.X > Frame.AbsolutePosition.X and Mouse.X < Frame.AbsolutePosition.X + Frame.AbsoluteSize.X and Mouse.Y > Frame.AbsolutePosition.Y and Mouse.Y < Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
end

function RuGuiCreateContext.IsNearDock(dock, margin)
    return IsNearDock(dock, margin)
end

function RuGuiCreateContext.AddExtension(self, Parent:UIBase, ExtensionID:string)
    local Extension = script.Extensions:FindFirstChild(ExtensionID)
    
    if Extension then
        local RequiredExtension = require(Extension)

        local newExtension = RequiredExtension.new(self, Parent)
        print(Parent.Name.."_"..ExtensionID.." was created.")
        self[Parent.Name.."_"..ExtensionID] = newExtension
    end
end


--#endregion

--#region User Interface Creation

-- // Creating User Interface
function RuGuiCreateContext:CreateDockFrame(Title:string, Properties:{Position:UDim2, Size:UDim2, Dockable:boolean?, StyleID:string?})
    return RequiredComponents.DockFrame.new(self, Title, Properties)
end

-- // Widgets are draggable its a cool system
function RuGuiCreateContext:CreateWidget(Title:string, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, DockAt:string?)
    return RequiredComponents.Widget.new(self, Title, Properties, DockAt)
end

-- // Frames get added into widgets
function RuGuiCreateContext:CreateFrame(Title, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, WidgetReference:UIBase)
    return RequiredComponents.Frame.new(self, Title, Properties, WidgetReference)
end

function RuGuiCreateContext:CreateScrollMenu(Title:string, Properties:{UseListLayout:boolean?, UseGridLayout:boolean?, LayoutPadding:UDim2?, SortOrder:Enum.SortOrder?, Position:UDim2, Size:UDim2}, ParentID:string)
    return RequiredComponents.ScrollMenu.new(self, Title, Properties, ParentID)
end

function RuGuiCreateContext:CreateMenu(Title:string, Properties:{UseListLayout:boolean?, UIPadding:UDim?, CellPadding:UDim2?, SortOrder:Enum.SortOrder?, Position:UDim2, Size:UDim2}, WidgetID:string)
    return RequiredComponents.Menu.new(self, Title, Properties, WidgetID)
end

function RuGuiCreateContext:CreateList(Title: string, Properties: {Position: UDim2?, FillDirection: Enum.FillDirection?, Size: UDim2?, AutoAligned: boolean?, UIPadding: UDim?, StyleID: string?, LayoutType: string?}, ParentReference: UIBase)
    return RequiredComponents.List.new(self, Title, Properties, ParentReference)
end

function RuGuiCreateContext:CreateButton(Title:string, Properties: {Position:UDim2, Size:UDim2, Text:string?, IsImage:boolean?, Image:string?, StyleID:string?}, ParentReference:UIBase)
    RequiredComponents.Button.new(self, Title, Properties, ParentReference)
end

function RuGuiCreateContext:CreateDropdown(Title:string, Properties: { Position: UDim2, Size: UDim2, Text: string?, IsImage: boolean?, Image: string?}, ParentReference: UIBase)
    return RequiredComponents.Dropdown.new(self, Title, Properties, ParentReference)
end

function RuGuiCreateContext:CreateLabel(Title: string, Properties: { Position: UDim2, Size: UDim2, Text: string?, IsImage: boolean?, Image: string?, Editable: boolean? }, ParentReference: UIBase)
    return RequiredComponents.Label.new(self, Title, Properties, ParentReference)
end

function RuGuiCreateContext:CreateTabList(Title: string, Properties: { Position: UDim2, Size: UDim2, StyleID:string? }, ParentReference: UIBase)
    return RequiredComponents.TabList.new(self, Title, Properties, ParentReference)
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