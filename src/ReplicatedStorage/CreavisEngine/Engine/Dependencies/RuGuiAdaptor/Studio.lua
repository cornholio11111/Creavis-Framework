return {
    -- Dock Frames
    [1] = {
        Type = "DockFrame",
        Name = "TopToolbar",
        Properties = {
            Position = UDim2.new(0.5, 0, 0.05, 0),
            Size = UDim2.new(1, 0, 0.1, 0)
        }
    },

    [2] = {
        Type = "DockFrame",
        Name = "LeftDock",
        Properties = {
            Position = UDim2.new(0.1, 0, 0.5, 0),
            Size = UDim2.new(0.2, 0, 0.8, 0)
        }
    },

    [3] = {
        Type = "DockFrame",
        Name = "RightDock",
        Properties = {
            Position = UDim2.new(0.9, 0, 0.5, 0),
            Size = UDim2.new(0.2, 0, 0.8, 0)
        }
    },

    [4] = {
        Type = "DockFrame",
        Name = "BottomDock",
        Properties = {
            Position = UDim2.new(0.5, 0, 0.9, 0),
            Size = UDim2.new(1, 0, 0.2, 0)
        }
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
        Parent = "ExplorerWidget"
    },

    -- Toolbar Items
    [9] = {
        Type = "Button",
        Name = "File",
        Properties = {
            Text = "File",
            Size = UDim2.new(0.1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        },
        Parent = "TopToolbar"
    },

    [10] = {
        Type = "Button",
        Name = "InstanceButton",
        Properties = {
            Text = "Button",
            Size = UDim2.fromScale(1, .1),
            Position = UDim2.fromScale(.8, 0)
        },
        Parent = "ExplorerList"
    }
}