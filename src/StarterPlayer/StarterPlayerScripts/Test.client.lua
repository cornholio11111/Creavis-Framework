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

local ExplorerMenu = Context:CreateMenu("ExplorerMenu", {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(1, 0, 1, 0)
}, "ExplorerPanel")

local function CreateInstanceBar(i)
    local ExplorerFrame = Context:CreateHorizontalList("ExplorerList", {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0)
    }, ExplorerMenu.Menu)

    Context:CreateButton("Button " .. i, {
        Text = "Button " .. tostring(i),
        Size = UDim2.fromScale(.5, 1),
        Position = UDim2.fromScale(.8, 0)
    }, ExplorerMenu.Menu)
end

-- Create buttons using :CreateButton
for i = 1, 5 do
    CreateInstanceBar(i)
end

-- Add Toolbar Items
local ToolbarButton = Instance.new("TextButton", TopToolbar.Dock)
ToolbarButton.Text = "File"
ToolbarButton.Size = UDim2.new(0.1, 0, 1, 0)
ToolbarButton.Position = UDim2.new(0, 0, 0, 0)

-- Display the UI
MainWindow.WindowScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
