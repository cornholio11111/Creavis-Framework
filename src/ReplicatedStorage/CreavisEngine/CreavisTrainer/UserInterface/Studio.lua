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
            Properties = {
                Position = UDim2.new(0.5, 0, 0.017, 0),
                Size = UDim2.new(1, 0, 0.032, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                ClipDescendants = true,
                Dockable = false
            },
        },

        QuickActions = { -- << Add tabs to this
            Type = "DockFrame",
            Name = "QuickActions",
            Properties = {
                Position = UDim2.new(0.5, 0, 0.07, 0),
                Size = UDim2.new(1, 0, 0.06, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Dockable = false
            },
        },

        LeftDock = {
            Type = "DockFrame",
            Name = "LeftDock",
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
            Properties = {
                Position = UDim2.new(0.5, 0, 0.9, 0),
                Size = UDim2.new(1, 0, 0.2, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Dockable = true
            },
        },

        -- // Quick Actions
        QuickActionsBackground = {
            Type = "List",
            Name = "QuickActionsPages",
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Horizontal,
                UIPadding = UDim.new(0, 0),
                LayoutType = "Page"
            },
            Parent = "QuickActions"
        },

    },

    -- Quick Actions
    QuickActions = {
        -- QA_ = {
        --     Type = "Widget",
        --     Name = "Toolbox",
        --     Properties = {
        --         Position = UDim2.new(0.9, 0, 0.5, 0),
        --         Size = UDim2.new(0.2, 0, 0.8, 0),

        --         BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        --         Scrollable = true,
        --     },
        --     Dock = "LeftDock",
        -- },
    },

    -- Panels and Widgets
    Panels = {
        -- Toolbox = {
        --     Type = "Widget",
        --     Name = "Toolbox",
        --     Properties = {
        --         Position = UDim2.new(0.9, 0, 0.5, 0),
        --         Size = UDim2.new(0.2, 0, 0.8, 0),

        --         BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        --         Scrollable = true,
        --     },
        --     Dock = "LeftDock",
        -- },

        ExplorerPanel = {
            Type = "Widget",
            Name = "Explorer",
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
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Horizontal,
                UIPadding = UDim.new(0, 0),
                LayoutType = "List"
            },
            Parent = "Toolbar"
        },

        QAHomePage = {
            Type = "List",
            Name = "HomePage",
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                FillDirection = Enum.FillDirection.Vertical,
                UIPadding = UDim.new(0, 0),
                LayoutType = "List",
            },
            Parent = "QuickActionsPages"
        },

        QAModelPage = {
            Type = "List",
            Name = "ModelPage",
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
            Properties = {
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, 0),
                Text = "File",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },

            Options = {
                NewWorkspace = {
                    Name = "NewWorkspace",
                    Properties = {
                        Text = "New Workspace",
                        StyleID = "Button",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                };

                Save = {
                    Name = "SaveWorkspace",
                    Properties = {
                        Text = "Save Workspace",
                        StyleID = "Button",
                    },

                    ConnectFunctionality = nil,
                    MouseButton1ClickActivation = nil,
                };

                Seperator = {Type = "Seperator", Size = "Full"};

                Exit = {
                    Name = "Exit",
                    Properties = {
                        Text = "File",
                        StyleID = "Button",
                    },

                    MouseButton1ClickActivation = nil,
                };
                
            },

            Parent = "ToolbarPanel"
        },

        EditButton = {
            Type = "Dropdown",
            Name = "Edit",
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
            Properties = {
                Position = UDim2.new(0.2, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, 0),
                Text = "Widgets",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },

            Options = {

            },

            Parent = "ToolbarPanel"
        },
    },
}
