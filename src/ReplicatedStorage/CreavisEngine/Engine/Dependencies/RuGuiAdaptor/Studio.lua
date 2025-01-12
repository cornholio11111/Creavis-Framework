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
-- << Design & Return of functionality
return {
    Functionality = Functionality;

    -- Dock Frames
    [1] = {
        Type = "DockFrame",
        Name = "TopToolbar",
        Properties = {
            Position = UDim2.new(0.5, 0, 0.05, 0),
            Size = UDim2.new(1, 0, 0.1, 0)
        },
        Folder = "Docks"
    },

    [2] = {
        Type = "DockFrame",
        Name = "LeftDock",
        Properties = {
            Position = UDim2.new(0.1, 0, 0.5, 0),
            Size = UDim2.new(0.2, 0, 0.8, 0)
        },
        Folder = "Docks"
    },

    [3] = {
        Type = "DockFrame",
        Name = "RightDock",
        Properties = {
            Position = UDim2.new(0.9, 0, 0.5, 0),
            Size = UDim2.new(0.2, 0, 0.8, 0)
        },
        Folder = "Docks"
    },

    [4] = {
        Type = "DockFrame",
        Name = "BottomDock",
        Properties = {
            Position = UDim2.new(0.5, 0, 0.9, 0),
            Size = UDim2.new(1, 0, 0.2, 0)
        },
        Folder = "Docks"
    },

    -- // Widgets
    [5] = {
        Type = "Widget",
        Name = "ToolboxPanel",
        Properties = {
            Position = UDim2.new(0.9, 0, 0.5, 0),
            Size = UDim2.new(0.2, 0, 0.8, 0)
        },
        Dock = "RightDock"
    },

    [6] = {
        Type = "Widget",
        Name = "OutputPanel",
        Properties = {
            Position = UDim2.new(0.5, 0, 0.9, 0),
            Size = UDim2.new(1, 0, 0.2, 0)
        },
        Dock = "BottomDock"
    },

    [7] = {
        Type = "Widget",
        Name = "ExplorerPanel",
        Properties = {
            Position = UDim2.new(0.1, 0, 0.5, 0),
            Size = UDim2.new(0.2, 0, 0.8, 0)
        },
        Dock = "LeftDock"
    },

    -- // other shiz
    [8] = {
        Type = "HorizontalList",
        Name = "ExplorerList",
        Properties = {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            UIPadding = UDim.new(.1, 0)
        },
        Parent = "ExplorerPanel"
    },

    -- Toolbar Items
    [9] = {
        Type = "Button",
        Name = "TBFile",
        Properties = {
            Text = "File",
            Size = UDim2.new(.1, 0, 1, 0),
            Position = UDim2.new(0.051, 0, 0.52, 0)
        },
        Parent = "TopToolbar"
    },

    [10] = {
        Type = "Button",
        Name = "TestButton",
        Properties = {
            Text = "DONT CLICK ME!",
            Size = UDim2.fromScale(1, .1),
            Position = UDim2.fromScale(.8, 0)
        },
        Parent = "ExplorerList"
    }
}

--[[

local function Register_ButtonClick(ButtonReference, Action)
    ButtonReference.MouseButton1Click:Connect(function()
        if Action then
            Action()
        end
    end)
end

local Functionality = {
    Type = "Functionality",
    ButtonActions = {
        OpenExplorer = function() print("Explorer Panel Opened") end,
        OpenProperties = function() print("Properties Panel Opened") end,
        OpenOutput = function() print("Output Panel Opened") end,
        OpenScriptEditor = function() print("Script Editor Opened") end,
        OpenToolbox = function() print("Toolbox Opened") end,
        OpenAssetManager = function() print("Asset Manager Opened") end,
        OpenGameSettings = function() print("Game Settings Opened") end,
        OpenTerrainEditor = function() print("Terrain Editor Opened") end,
        OpenTeamCreate = function() print("Team Create Opened") end,
        RunCommand = function() print("Command Executed") end,
    },
}

return {
    Functionality = Functionality,

    -- Dock Frames
    DockFrames = {
        TopToolbar = {
            Type = "DockFrame",
            Name = "TopToolbar",
            Properties = {
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0.05, 0),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            },
        },
        LeftDock = {
            Type = "DockFrame",
            Name = "LeftDock",
            Properties = {
                Position = UDim2.new(0, 0, 0.05, 0),
                Size = UDim2.new(0.2, 0, 0.95, 0),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            },
        },
        RightDock = {
            Type = "DockFrame",
            Name = "RightDock",
            Properties = {
                Position = UDim2.new(0.8, 0, 0.05, 0),
                Size = UDim2.new(0.2, 0, 0.95, 0),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            },
        },
        BottomDock = {
            Type = "DockFrame",
            Name = "BottomDock",
            Properties = {
                Position = UDim2.new(0.2, 0, 0.8, 0),
                Size = UDim2.new(0.6, 0, 0.2, 0),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            },
        },
        MainDock = {
            Type = "DockFrame",
            Name = "MainDock",
            Properties = {
                Position = UDim2.new(0.2, 0, 0.05, 0),
                Size = UDim2.new(0.6, 0, 0.75, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            },
        },
    },

    -- Panels and Widgets
    Panels = {
        ExplorerPanel = {
            Type = "Widget",
            Name = "ExplorerPanel",
            Properties = {
                Position = UDim2.new(0, 0, 0.05, 0),
                Size = UDim2.new(0.2, 0, 0.4, 0),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                Title = "Explorer",
            },
            Dock = "LeftDock",
        },
        PropertiesPanel = {
            Type = "Widget",
            Name = "PropertiesPanel",
            Properties = {
                Position = UDim2.new(0, 0, 0.45, 0),
                Size = UDim2.new(0.2, 0, 0.55, 0),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                Title = "Properties",
            },
            Dock = "LeftDock",
        },
        OutputPanel = {
            Type = "Widget",
            Name = "OutputPanel",
            Properties = {
                Position = UDim2.new(0.2, 0, 0.8, 0),
                Size = UDim2.new(0.6, 0, 0.2, 0),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Title = "Output",
            },
            Dock = "BottomDock",
        },
        ScriptEditor = {
            Type = "Widget",
            Name = "ScriptEditor",
            Properties = {
                Position = UDim2.new(0.2, 0, 0.05, 0),
                Size = UDim2.new(0.6, 0, 0.75, 0),
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Title = "Script Editor",
            },
            Dock = "MainDock",
        },
        Toolbox = {
            Type = "Widget",
            Name = "Toolbox",
            Properties = {
                Position = UDim2.new(0.8, 0, 0.05, 0),
                Size = UDim2.new(0.2, 0, 0.95, 0),
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                Title = "Toolbox",
            },
            Dock = "RightDock",
        },
    },

    -- Toolbar Buttons
    Toolbar = {
        FileButton = {
            Type = "Button",
            Name = "FileButton",
            Properties = {
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, -20),
                Text = "File",
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = Color3.fromRGB(200, 200, 200),
            },
            Parent = "TopToolbar",
        },
        EditButton = {
            Type = "Button",
            Name = "EditButton",
            Properties = {
                Position = UDim2.new(0.1, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, -20),
                Text = "Edit",
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = Color3.fromRGB(200, 200, 200),
            },
            Parent = "TopToolbar",
        },
        ViewButton = {
            Type = "Button",
            Name = "ViewButton",
            Properties = {
                Position = UDim2.new(0.2, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, -20),
                Text = "View",
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                TextColor3 = Color3.fromRGB(200, 200, 200),
            },
            Parent = "TopToolbar",
        },
    },
}
]]--