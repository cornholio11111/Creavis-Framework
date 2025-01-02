-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local RuGui = require(ReplicatedStorage.RuGui) -- Adjust this to the correct location of your RuGui module

-- -- Create the main window
-- local MainWindow = RuGui.CreateWindow(1, 1, "GameEngineUI")
-- MainWindow:CreateContext()

-- -- Access the context
-- local Context = MainWindow.Context

-- Context:SetStyleSheet(require(ReplicatedStorage.RuGui.StyleSheet))

-- -- Create Dock Frames
-- local TopToolbar = Context:CreateDockFrame("TopToolbar", {
--     Position = UDim2.new(0.5, 0, 0.05, 0),
--     Size = UDim2.new(1, 0, 0.1, 0)
-- })

-- local LeftDock = Context:CreateDockFrame("LeftDock", {
--     Position = UDim2.new(0.1, 0, 0.5, 0),
--     Size = UDim2.new(0.2, 0, 0.8, 0)
-- })

-- local RightDock = Context:CreateDockFrame("RightDock", {
--     Position = UDim2.new(0.9, 0, 0.5, 0),
--     Size = UDim2.new(0.2, 0, 0.8, 0)
-- })

-- local BottomDock = Context:CreateDockFrame("BottomDock", {
--     Position = UDim2.new(0.5, 0, 0.9, 0),
--     Size = UDim2.new(1, 0, 0.2, 0)
-- })

-- -- Create Widgets
-- Context:CreateWidget("ToolboxPanel", {
--     Position = UDim2.new(0.9, 0, 0.5, 0),
--     Size = UDim2.new(0.2, 0, 0.8, 0)
-- }, "RightDock")

-- Context:CreateWidget("OutputPanel", {
--     Position = UDim2.new(0.5, 0, 0.9, 0),
--     Size = UDim2.new(1, 0, 0.2, 0)
-- }, "BottomDock")

-- -- Add Toolbar Items
-- local ToolbarButton = Instance.new("TextButton", TopToolbar.Dock)
-- ToolbarButton.Text = "File"
-- ToolbarButton.Size = UDim2.new(0.1, 0, 1, 0)
-- ToolbarButton.Position = UDim2.new(0, 0, 0, 0)

-- -- Display the UI
-- MainWindow.WindowScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RuGui = require(ReplicatedStorage.RuGui) -- Adjust this to the correct location of your RuGui module

-- Create the main window
local MainWindow = RuGui.CreateWindow(1, 1, "GameEngineUI")
MainWindow:CreateContext()

-- Access the context
local Context = MainWindow.Context

Context:SetStyleSheet(require(ReplicatedStorage.RuGui.StyleSheet))

-- Create Dock Frames
local TopToolbar = Context:CreateDockFrame("TopToolbar", {
    Position = UDim2.new(0.5, 0, 0.05, 0),
    Size = UDim2.new(1, 0, 0.1, 0)
})

local LeftDock = Context:CreateDockFrame("LeftDock", {
    Position = UDim2.new(0.1, 0, 0.5, 0),
    Size = UDim2.new(0.2, 0, 0.8, 0)
})

local RightDock = Context:CreateDockFrame("RightDock", {
    Position = UDim2.new(0.9, 0, 0.5, 0),
    Size = UDim2.new(0.2, 0, 0.8, 0)
})

local BottomDock = Context:CreateDockFrame("BottomDock", {
    Position = UDim2.new(0.5, 0, 0.9, 0),
    Size = UDim2.new(1, 0, 0.2, 0)
})

-- Create Widgets
Context:CreateWidget("ToolboxPanel", {
    Position = UDim2.new(0.9, 0, 0.5, 0),
    Size = UDim2.new(0.2, 0, 0.8, 0)
}, "RightDock")

Context:CreateWidget("OutputPanel", {
    Position = UDim2.new(0.5, 0, 0.9, 0),
    Size = UDim2.new(1, 0, 0.2, 0)
}, "BottomDock")

local ExplorerWidget = Context:CreateWidget("ExplorerPanel", {
    Position = UDim2.new(0.1, 0, 0.5, 0),
    Size = UDim2.new(0.2, 0, 0.8, 0)
}, "LeftDock")

-- Add a horizontal list to the Explorer
local ExplorerFrame = Context:CreateHorizontalList("Test", {AutoAligned = true}, ExplorerWidget.Widget)
local UIListLayout = Instance.new("UIListLayout", ExplorerFrame.List)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Create buttons using :CreateButton
for i = 1, 5 do
    Context:CreateButton("Button " .. i, {
        Parent = ExplorerFrame.List,
        Size = UDim2.new(0, 100, 0, 50),
        Text = "Button " .. tostring(i)
    }, ExplorerWidget.Widget)
end

-- Add Toolbar Items
local ToolbarButton = Instance.new("TextButton", TopToolbar.Dock)
ToolbarButton.Text = "File"
ToolbarButton.Size = UDim2.new(0.1, 0, 1, 0)
ToolbarButton.Position = UDim2.new(0, 0, 0, 0)

-- Display the UI
MainWindow.WindowScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
