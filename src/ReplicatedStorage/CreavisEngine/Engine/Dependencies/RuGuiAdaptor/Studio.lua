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

return {
    Functionality = Functionality,

    -- Dock Frames
    Docks = {
        Toolbar = {
            Type = "DockFrame",
            Name = "Toolbar",
            Properties = {
                Position = UDim2.new(0.5, 0, 0.05, 0),
                Size = UDim2.new(1, 0, 0.1, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
            },
        },

        LeftDock = {
            Type = "DockFrame",
            Name = "LeftDock",
            Properties = {
                Position = UDim2.new(0.1, 0, 0.45, 0),
                Size = UDim2.new(0.2, 0, 0.7, 0),
                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
            },
        },

        RightDock = {
            Type = "DockFrame",
            Name = "RightDock",
            Properties = {
                Position = UDim2.new(0.9, 0, 0.45, 0),
                Size = UDim2.new(0.2, 0, 0.7, 0),
                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
            },
        },

        MainDock = {
            Type = "DockFrame",
            Name = "BottomDock",
            Properties = {
                Position = UDim2.new(0.5, 0, 0.9, 0),
                Size = UDim2.new(1, 0, 0.2, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
            },
        },
    },

    -- Panels and Widgets
    Panels = {
        Toolbox = {
            Type = "Widget",
            Name = "Toolbox",
            Properties = {
                Position = UDim2.new(0.9, 0, 0.5, 0),
                Size = UDim2.new(0.2, 0, 0.8, 0),

                BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                Scrollable = true,
            },
            Dock = "LeftDock",
        },

        ExplorerPanel = {
            Type = "Widget",
            Name = "ExplorerPanel",
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
            Name = "Widget_PropertiesPanel",
            Properties = {
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Scrollable = true,
            },
            Dock = "RightDock",
        },

        OutputPanel = {
            Type = "Widget",
            Name = "OutputPanel",
            Properties = {
                Position = UDim2.new(0.5, 0, 0.9, 0),
                Size = UDim2.new(1, 0, 0.2, 0)
            },
            Dock = "BottomDock"
        },
    },

    -- Toolbar Buttons
    Toolbar = {
        FileButton = {
            Type = "Button",
            Name = "Button_File",
            Properties = {
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, -20),
                Text = "File",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },
            Parent = "DockFrame_TopToolbar",
        },
        EditButton = {
            Type = "Button",
            Name = "Button_Edit",
            Properties = {
                Position = UDim2.new(0.1, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, -20),
                Text = "Edit",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },
            Parent = "DockFrame_TopToolbar",
        },
        ViewButton = {
            Type = "Button",
            Name = "Button_View",
            Properties = {
                Position = UDim2.new(0.2, 10, 0, 10),
                Size = UDim2.new(0.1, 0, 1, -20),
                Text = "View",
                BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                TextColor3 = Color3.fromRGB(0, 0, 0),
            },
            Parent = "DockFrame_TopToolbar",
        },
    },
}
