local RunService = game:GetService("RunService")
local Frame = require(script.Parent.Parent.Components.Base.Frame)

local Resize = {}
Resize.__index = Resize

local BarProperties = {
    Top = { Position = UDim2.new(0.5, 0, 0, -2), Size = UDim2.new(1, 0, 0, 5)},
    Bottom = { Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(1, 0, 0, 5)},
    Left = { Position = UDim2.new(0, -2, 0.5, 0), Size = UDim2.new(0, 5, 1, 0)},
    Right = { Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 5, 1, 0)},
}

function Resize.new(RuGuiReference, TriggerWindow: UIBase)
    local self = setmetatable({}, Resize)
    self.RuGuiReference = RuGuiReference
    self.TriggerWindow = TriggerWindow

    self.StartSize = nil
    self.StartPosition = nil
    self.StartMousePosition = nil
    self.ActiveBar = nil
    self.BarOffsets = {}

    self:InitializeBars()
    return self
end

function Resize:InitializeBars()

    local ResizeFolder = self.TriggerWindow:FindFirstChild("Resize")
    if not ResizeFolder then
        ResizeFolder = Instance.new("Folder", self.TriggerWindow)
        ResizeFolder.Name = "Resize"
    end

    self.Bars = {}
    for barName, props in pairs(BarProperties) do
        local Bar = Frame.new(self.RuGuiReference, barName, {
            Position = props.Position,
            Size = props.Size,
            StyleID = "ResizeBar",
        }, ResizeFolder)

        Bar.BackgroundTransparency = 1
        Bar.ZIndex = 999

        local DragDetector = self:SetupDrag(Bar, barName)

        if barName == "Top" or barName == "Bottom" then
            DragDetector.ActivatedCursorIcon = "rbxassetid://116433389982048"
            DragDetector.CursorIcon = "rbxassetid://116433389982048"
        elseif barName == "Left" or barName == "Right" then
            DragDetector.ActivatedCursorIcon = "rbxassetid://118758886502244"
            DragDetector.CursorIcon = "rbxassetid://118758886502244"
        end

        Bar.MouseEnter:Connect(function()
            self.ActiveBar = barName
        end)

        Bar.MouseLeave:Connect(function()
            if self.ActiveBar == barName then
                self.ActiveBar = nil
                self.RuGuiReference.MouseIcon = ""
            end
        end)

        self.Bars[barName] = Bar
        self.BarOffsets[barName] = {X = props.Position.X.Offset, Y = props.Position.Y.Offset}

        if barName == "Top" or barName == "Bottom" then
            self.BarOffsets[barName].StartDistance = self.TriggerWindow.Position.Y.Offset - Bar.Position.Y.Offset
        elseif barName == "Left" or barName == "Right" then
            self.BarOffsets[barName].StartDistance = self.TriggerWindow.Position.X.Offset - Bar.Position.X.Offset
        end
    end
end

function Resize:SetupDrag(Bar, barName)
    local DragDetector = Instance.new("UIDragDetector", Bar)
    DragDetector.BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject

    self.StartSize = self.TriggerWindow.Size
    self.StartPosition = self.TriggerWindow.Position

    DragDetector.DragStart:Connect(function(mousePosition)
        if self.ActiveBar == barName then
            self.StartSize = self.TriggerWindow.Size
            self.StartPosition = self.TriggerWindow.Position
            self.StartMousePosition = mousePosition

            self.RenderStepHandler = self:CreateRenderStepHandler(barName)
            RunService:BindToRenderStep('Drag_'..barName, 1, self.RenderStepHandler)
        end
    end)

    DragDetector.DragEnd:Connect(function()
        self:ResetBars()
        self.ActiveBar = nil
        self.StartMousePosition = nil
        self.StartSize = nil
        self.StartPosition = nil
        self.RuGuiReference.MouseIcon = ""

        RunService:UnbindFromRenderStep('Drag_'..barName)
    end)

    return DragDetector
end

function Resize:CreateRenderStepHandler(barName)
    return function(_, dt)
        local delta = self:GetMouseDelta(barName)

        if delta then
            self:UpdateSize(delta, barName)
        end
    end
end

function Resize:GetMouseDelta(barName)
    if not self.StartMousePosition then return nil end

    local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
    local delta = mousePosition - self.StartMousePosition
    return delta
end

function Resize:UpdateSize(delta, barName)
    local newSize = self.StartSize
    local newPosition = self.StartPosition

    local barOffset = self.BarOffsets[barName]

    if barName == "Top" then
        local newHeight = self.StartSize.Y.Offset - delta.Y
        newSize = UDim2.new(newSize.X.Scale, newSize.X.Offset, 0, math.max(newHeight, 20))
        newPosition = UDim2.new(newPosition.X.Scale, newPosition.X.Offset, newPosition.Y.Scale, newPosition.Y.Offset + delta.Y)
    elseif barName == "Bottom" then
        local newHeight = self.StartSize.Y.Offset + delta.Y
        newSize = UDim2.new(newSize.X.Scale, newSize.X.Offset, 0, math.max(newHeight, 20))
    elseif barName == "Left" then
        local newWidth = self.StartSize.X.Offset - delta.X
        newSize = UDim2.new(0, math.max(newWidth, 20), newSize.Y.Scale, newSize.Y.Offset)
        newPosition = UDim2.new(newPosition.X.Scale, newPosition.X.Offset + delta.X, newPosition.Y.Scale, newPosition.Y.Offset)
    elseif barName == "Right" then
        local newWidth = self.StartSize.X.Offset + delta.X
        newSize = UDim2.new(0, math.max(newWidth, 20), newSize.Y.Scale, newSize.Y.Offset)
    end

    if barName == "Top" then
        newPosition = UDim2.new(newPosition.X.Scale, newPosition.X.Offset, newPosition.Y.Scale, newPosition.Y.Offset - delta.Y)
    elseif barName == "Left" then
        newPosition = UDim2.new(newPosition.X.Scale, newPosition.X.Offset - delta.X, newPosition.Y.Scale, newPosition.Y.Offset)
    end

    if barName == "Bottom" then
        newPosition = self.StartPosition
    elseif barName == "Right" then
        newPosition = self.StartPosition
    end

    self.TriggerWindow.Size = newSize
    self.TriggerWindow.Position = newPosition
end

function Resize:ResetBars()
    local TriggerSize = self.TriggerWindow.Size

    for barName, props in pairs(BarProperties) do
        local Bar = self.Bars[barName]
        if Bar then
            Bar.Position = props.Position
        end
    end
end

return Resize