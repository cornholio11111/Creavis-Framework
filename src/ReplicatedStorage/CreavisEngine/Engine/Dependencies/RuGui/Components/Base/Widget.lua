local RunService = game:GetService("RunService")
local Widget = {}

function Widget.new(self, Title:string, Properties:{Position:UDim2, Size:UDim2, StyleID:string?, CanDock:boolean?, HeaderTitle:string?}, DockAt:string?)
    DockAt = DockAt or "None"
    
    if not Properties.DockAt then Properties.DockAt = "None" end
    if not Properties.StyleID then Properties.StyleID = "Widget" end
    if not Properties.CanDock then Properties.CanDock = true end
    if not Properties.HeaderTitle then Properties.HeaderTitle = Title end

    local Widget = Instance.new("Frame", self.RuGuiData.WindowBaseFrame.Widgets)
    Widget.Name = Title
    Widget.LayoutOrder = #self.Widgets + 1
    Widget.ZIndex = #self.Widgets + 1
    Widget.AnchorPoint = Vector2.new(.5, .5)
    Widget:SetAttribute("Type", "Widget")
    Widget:SetAttribute("Style", Properties.StyleID)
    Widget:SetAttribute("D_Index", Widget.ZIndex)

    Widget:SetAttribute("CanDock", Properties.CanDock)

    Widget:SetAttribute("DockID", 'nil')

    local DragHandle = Instance.new("Frame")
    DragHandle.Size = UDim2.new(1, 0, 0, 10)
    DragHandle.AnchorPoint = Vector2.new(0.5, 0)
    DragHandle.Position = UDim2.new(0.5, 0, 0, 0)
    DragHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    DragHandle.Name = "DragHandle"
    DragHandle.ZIndex = 2
    DragHandle.LayoutOrder = 2
    DragHandle.Parent = Widget
    DragHandle:SetAttribute("Type", "WidgetHeader")
    DragHandle:SetAttribute("Style", "WidgetHeader")

    local UIGradient = Instance.new("UIGradient", DragHandle)
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(207, 207, 207)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 168)),
    })
    UIGradient.Rotation = 90

    -- Header label (Title)
    local Label = Instance.new("TextLabel")
    Label.Name = "Title"
    Label.Size = UDim2.new(0.8, 0, .8, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0) -- Slight left margin
    Label.BackgroundTransparency = 1
    Label.Text = Properties.HeaderTitle
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Center
    Label.Parent = DragHandle
    Label:SetAttribute("Type", "WidgetHeaderText")
    Label:SetAttribute("Style", "WidgetHeaderText")

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 10, 0, 10)
    CloseButton.AnchorPoint = Vector2.new(1, .5)
    CloseButton.Position = UDim2.new(1, 0, .5, 0) -- Right-aligned
    CloseButton.BackgroundTransparency = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 85, 85)
    CloseButton.TextScaled = true
    CloseButton.Font = Enum.Font.GothamMedium
    CloseButton.TextXAlignment = Enum.TextXAlignment.Center
    CloseButton.Parent = DragHandle
    CloseButton:SetAttribute("Type", "WidgetHeaderExit")
    CloseButton:SetAttribute("Style", "WidgetHeaderExit")

    local UICornerClose = Instance.new("UICorner", CloseButton)
    UICornerClose.CornerRadius = UDim.new(1, 0)

    local DragDetector = Instance.new("UIDragDetector", Widget)
    DragDetector.Name = "DragDetector"
    DragDetector.ActivatedCursorIcon = ""
    DragDetector.CursorIcon = ""
    DragDetector.Enabled = false

    local CanEditDragDetector = true
    local IsDragging = false
    local wannaDock = nil

    CloseButton.MouseButton1Click:Connect(function()
        Widget:SetAttribute("Active", false)
        Widget.Visible = false
    end)

    local function BringToFront(widget)
        for _, w in pairs(self.Widgets) do
            w.ZIndex = w:GetAttribute("D_Index")
        end
        widget.ZIndex = 100
    end

    DragDetector.DragStart:Connect(function()
        IsDragging = true
        CanEditDragDetector = false
        BringToFront(Widget)
        self.CurrentDraggedWidget = Title

        if not self.Connections["DragRenderStepped"..Title] then
            self.Connections["DragRenderStepped"..Title] = RunService:BindToRenderStep("DragRenderStepped"..Title, 0, function()
                if IsDragging then
                    for _, dock in pairs(self.Docks) do
                        dock = dock.Dock
                        if dock:GetAttribute("Dockable") and self.IsNearDock(dock, 15) and Properties.CanDock then
                            wannaDock = dock

                            dock.BackgroundColor3 = Color3.fromRGB(0, 0, 225)
                            dock.BackgroundTransparency = .5

                        else
                            if wannaDock == dock then
                                wannaDock = nil
                            end
                            self.ApplyStyle(self, dock)
                        end

                        task.wait()
                    end
                end
            end)
        end
    end)

    DragDetector.DragEnd:Connect(function()
        IsDragging = false
        CanEditDragDetector = true

        RunService:UnbindFromRenderStep("DragRenderStepped"..Title)

        if wannaDock ~= nil and Properties.CanDock then
            self.ApplyStyle(self, wannaDock)
            self:DockWidget(Title, wannaDock.Name)
        end

        self.LastDraggedWidget = Title
    end)

    DragHandle.MouseEnter:Connect(function()
        if CanEditDragDetector then
            DragDetector.Enabled = true
        end
    end)

    DragHandle.MouseLeave:Connect(function()
        if CanEditDragDetector then
            DragDetector.Enabled = false
        end
    end)

    local DockReference = nil

    if DockAt == "None" then
        Widget.Size = Properties.Size
        Widget.Position = Properties.Position
    else
        DockReference = self.Docks[string.lower(DockAt)]

        if not DockReference then
            warn(DockAt.." wasn't found, check your spelling maybe?")
            error(self.Docks)
        end

        DockReference = DockReference.Dock

        Widget.Position = DockReference.Position
        Widget.Size = DockReference.Size
    end

    Widget:SetAttribute("Docked", (DockAt ~= "None" and DockReference ~= nil))
    Widget:SetAttribute("DockedAt", DockAt)

    self.Widgets[string.lower(Title)] = Widget
    self.Objects[string.lower(Title)] = Widget
    self.AddExtension(self, Widget, 'Resize')
    self.ApplyStyle(self, DragHandle)
    self.ApplyStyle(self, Widget)

    return Widget, Widget.LayoutOrder
end

return Widget