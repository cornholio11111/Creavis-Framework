local Label = {}

function Label.new(self, Title: string, Properties: { Position: UDim2, Size: UDim2, Text: string?, IsImage: boolean?, Image: string?, Editable: boolean? }, ParentReference: UIBase)
    if not ParentReference then error("Parent reference is required to create a label.") end

    local Label
    if Properties.IsImage then
        Label = Instance.new("ImageLabel", ParentReference)
        Label.Image = Properties.Image or ""
        Label.ScaleType = Enum.ScaleType.Fit
        Label.BackgroundTransparency = 1
    elseif Properties.Editable then
        Label = Instance.new("TextBox", ParentReference)
        Label.Text = Properties.Text or ""
        Label.ClearTextOnFocus = false
        Label.TextEditable = true
    else
        Label = Instance.new("TextLabel", ParentReference)
        Label.Text = Properties.Text or ""
    end

    Label.Name = Title
    Label.Position = Properties.Position
    Label.Size = Properties.Size
    Label.LayoutOrder = #ParentReference:GetChildren() + 1
    Label.AnchorPoint = Vector2.new(0.5, 0.5)
    Label.TextScaled = true
    Label.Font = Enum.Font.SourceSans
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundColor3 = Color3.new(0, 0, 0)
    Label.BackgroundTransparency = 0.5

    if Properties.IsImage then
        Label.SizeConstraint = Enum.SizeConstraint.RelativeXY
    elseif Properties.Editable then
        Label.PlaceholderText = "Enter text here..."
        Label.TextWrapped = true
    else
        Label.TextWrapped = true
    end

    return Label, Label.LayoutOrder
end

return Label