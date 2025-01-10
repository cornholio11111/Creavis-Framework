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