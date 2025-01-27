local function Register_TestButton_MouseButton1Click(ButtonReference)
    ButtonReference.MouseButton1Click:Connect(function()
        print("Thats fire bro wtf")
    end)
end

local Functionality = { Type = "Functionality";
    TestButton = { -- // Can seperate in their single functions or all in one your choice
        MouseButton1Click = Register_TestButton_MouseButton1Click,
    };
}

--[[

    TODO:
    
    - add output panel
    - add explorer
    - add properties panel
    - add movement tools

    - add top navigation buttons : DONE
]]

return {
    Functionality = Functionality,

    -- Dock Frames
    Docks = {
        Toolbar = { -- << Holds 'File', 'Edit', & 'Widgets'
            Type = "DockFrame",
            Name = "Toolbar",
            Priority = 1,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.017, 0),
                Size = UDim2.new(1, 0, 0.032, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                ClipDescendants = true,
                Dockable = false,
                StyleID = "Toolbar"
            },
        },

        QuickActions = { -- << Add tabs to this
            Type = "DockFrame",
            Name = "QuickActions",
            Priority = 2,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.069, 0),
                Size = UDim2.new(1, 0, 0.065, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Dockable = false
            },
        },

        LeftDock = {
            Type = "DockFrame",
            Name = "LeftDock",
            Priority = 3,
            Properties = {
                Position = UDim2.new(0.1, 0, 0.45, 0),
                Size = UDim2.new(0.2, 0, 0.7, 0),
                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                Dockable = true
            },
        },

        RightDock = {
            Type = "DockFrame",
            Name = "RightDock",
            Priority = 4,
            Properties = {
                Position = UDim2.new(0.9, 0, 0.45, 0),
                Size = UDim2.new(0.2, 0, 0.7, 0),
                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                Dockable = true
            },
        },

        BottomDock = {
            Type = "DockFrame",
            Name = "BottomDock",
            Priority = 5,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.9, 0),
                Size = UDim2.new(1, 0, 0.2, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Dockable = true
            },
        },
    },

    -- Panels and Widgets
    Panels = {
        -- // Quick Actions
        QuickActionsPages = { -- // Title, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, WidgetID
            Type = "Frame",
            Name = "QuickActionsPages",
            Priority = 6,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 100,
            },
            Parent = "QuickActions"
        },

        ExplorerPanel = {
            Type = "Widget",
            Name = "Explorer",
            Priority = 1,
            Properties = {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Scrollable = true,
            },
            Dock = "RightDock",
        },

        PropertiesPanel = {
            Type = "Widget",
            Name = "Properties",
            Priority = 2,
            Properties = {
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Scrollable = true,
            },
            Dock = "LeftDock",
        },

        OutputPanel = {
            Type = "Widget",
            Name = "Output",
            Priority = 3,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Scrollable = true
            },
            Dock = "BottomDock"
        },

        ToolbarPanel = {
            Type = "List",
            Name = "ToolbarPanel",
            Priority = 4,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                UIPadding = UDim.new(0, 0),
                LayoutType = "List",
            },
            Parent = "Toolbar"
        },

        QAHomePage = {
            Type = "List",
            Name = "HomePage",
            Priority = 5,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Vertical,
                LayoutType = "Grid",
                CellSize = UDim2.new(0.2, 0, 0.8, 0),
            },
            Parent = "QuickActionsPages"
        },

        QAModelPage = {
            Type = "List",
            Name = "ModelPage",
            Priority = 6,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Vertical,
                UIPadding = UDim.new(0, 0),
                LayoutType = "List",
            },
            Parent = "QuickActionsPages"
        },

        QAViewPage = {
            Type = "List",
            Name = "ViewPage",
            Priority = 7,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Vertical,
                UIPadding = UDim.new(0, 0),
                LayoutType = "List",
            },
            Parent = "QuickActionsPages"
        },

        QAPluginPage = {
            Type = "List",
            Name = "PluginPage",
            Priority = 8,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Vertical,
                UIPadding = UDim.new(0, 0),
                LayoutType = "List",
            },
            Parent = "QuickActionsPages"
        },

    },

    -- Toolbar Buttons
    Toolbar = {
        FileButton = {
            Type = "Dropdown",
            Name = "File",
            Priority = 1,
            Properties = {
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, 0),
                Text = "File",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },

            Options = {
                NewWorkspace = {
                    Name = "NewMod",
                    Priority = 1,
                    Properties = {
                        Text = "Create New Workspace",
                        StyleID = "OptionsButton",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                },

                Save = {
                    Name = "SaveMod",
                    Priority = 2,
                    Properties = {
                        Text = "Save Workspace",
                        StyleID = "OptionsButton",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                },

                Seperator = {Type = "Seperator", Priority = 3, Size = "Full"},

                Exit = {
                    Name = "Exit",
                    Priority = 4,
                    Properties = {
                        Text = "Exit",
                        StyleID = "OptionsButton",
                    },

                    MouseButton1ClickActivation = nil,
                },
            },

            Parent = "ToolbarPanel"
        },

        EditButton = {
            Type = "Dropdown",
            Name = "Edit",
            Priority = 2,
            Properties = {
                Position = UDim2.new(0.1, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, 0),
                Text = "Edit",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },

            Options = {

            },

            Parent = "ToolbarPanel"
        },

        WidgetButton = {
            Type = "Dropdown",
            Name = "Widgets",
            Priority = 3,
            Properties = {
                Position = UDim2.new(0.2, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, 0),
                Text = "Widgets",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },

            Options = {
                ToggleExplorerPanel = {
                    Name = "ExplorerPanelToggle",
                    Priority = 1,
                    Properties = {
                        Text = "Explorer Panel",
                        StyleID = "OptionsButton",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                },

                TogglePropertiesPanel = {
                    Name = "PropertiesPanelToggle",
                    Priority = 1,
                    Properties = {
                        Text = "Properties Panel",
                        StyleID = "OptionsButton",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                },

                ToggleOutput = {
                    Name = "OutputPanelToggle",
                    Priority = 1,
                    Properties = {
                        Text = "Output Panel",
                        StyleID = "OptionsButton",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                },
            },

            Parent = "ToolbarPanel"
        },
    },

    
    -- Quick Actions
    QuickActions = {
        QAHomePage_MovementTools = {
            Type = "List",
            Name = "HomePageMovementTools",
            Priority = 1,
            Properties = {
                Size = UDim2.new(0.2, 0, 1, 0),

                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                Scrollable = true,
            },
            Parent = "HomePage",
        },

        QAHomePage_MovementTools_Select = {
            Type = "StackedButton",
            Name = "Select",
            Priority = 2,
            Properties = {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 30, 0, 30),
                IsImage = true,
                Image = "",

                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                Scrollable = true,
            },
            Parent = "HomePageMovementTools",
        },

    },
}