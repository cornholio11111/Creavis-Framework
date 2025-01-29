-- << Where players can find their mods they have created, similar to Roblox Studio

local Functionality = { Type = "Functionality";

}

return {
    Functionality = Functionality;

    Docks = {
        Toolbar = { -- << Holds 'File', 'Edit'
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
                Position = UDim2.new(0.029, 0, 0.55, 0),
                Size = UDim2.new(0.058, 0, 0.9, 0),
                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                Dockable = true
            },
        },

        BackgroundDock = {
            Type = "DockFrame",
            Name = "BackgroundDock",
            Priority = 4,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Dockable = false,
                ZIndex = -100,
            },
        },
    };

    Panels = {
        LeftWidget = {
            Type = "List",
            Name = "LeftWidget",
            Priority = 1,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, .2),
                UIPadding = UDim.new(0, .2),
                Scrollable = true,
                StyleID = "uiframe",
            },
            Parent = "LeftDock",
        },
        
        QuickActionsPages = { -- // Title, Properties:{Position:UDim2, Size:UDim2, StyleID:string?}, WidgetID
            Type = "Frame",
            Name = "QuickActionsPages",
            Priority = 2,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 100,
            },
            Parent = "QuickActions"
        },
        
        ToolbarPanel = {
            Type = "List",
            Name = "ToolbarPanel",
            Priority = 3,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 0),
                UIPadding = UDim.new(0, 0),
                LayoutType = "List",
            },
            Parent = "Toolbar"
        },

        BackgroundFrame = {
            Type = "Frame",
            Name = "BackgroundFrame",
            Priority = 4,
            Properties = {
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                StyleID = "Background",
                ZIndex = -100,
            },
            Parent = "BackgroundDock"
        },

        -- << 4 Buttons, My Mods, Team Mods, Archives

        MyModsButton = {
            Type = "StackedButton",
            Name = "MyMods",
            Priority = 5,
            Properties = {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, .23, 0),
                Text = "My Mods",
                Image = "rbxassetid://117259180607823",
                TextScaled = true
            },
            Parent = "LeftWidget"
        },

        ModArchivesButton = {
            Type = "StackedButton",
            Name = "ModArchives",
            Priority = 7,
            Properties = {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, .23, 0),
                Text = "Mod Archives",
                Image = "rbxassetid://128372145651723",
                TextScaled = true
            },
            Parent = "LeftWidget"
        },

        TeamModsButton = {
            Type = "StackedButton",
            Name = "TeamMods",
            Priority = 8,
            Properties = {
                Position = UDim2.new(.5, 0, .5, 0),
                Size = UDim2.new(1, 0, .23, 0),
                Text = "Team Mods",
                Image = "rbxassetid://11577689639",
                TextScaled = true
            },
            Parent = "LeftWidget"
        },

    };

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
    },

    QuickActions = {

    }
}