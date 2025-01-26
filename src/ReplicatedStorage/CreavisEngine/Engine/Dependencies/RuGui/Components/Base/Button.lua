local Button = {}

function Button.new(self, Title:string, Properties: {Position:UDim2, Size:UDim2, Text:string?, IsImage:boolean?, Image:string?, StyleID:string?}, ParentReference:UIBase)
    if not ParentReference then error("Parent reference is required to create a Button.") end
    local Button
    local _type

    Properties.StyleID = Properties.StyleID or "None"

    if Properties.IsImage then
        Button = Instance.new("ImageButton")
        Button.Image = Properties.Image
        _type = "ImageButton"
    else
        Button = Instance.new("TextButton")
        Button.Text = Properties.Text
        _type = "TextButton"
    end

    if Properties.StyleID == "None" then
        Properties.StyleID = _type
    end

    Button.Name = Title

    local LOrder = #ParentReference:GetChildren()
    if LOrder > 0 then
        LOrder += 1
    end

    Button.LayoutOrder = LOrder
    Button.AnchorPoint = Vector2.new(.5, .5)
    Button.Size = Properties.Size or UDim2.fromScale(.2, .2)
    Button.Position = Properties.Position
    
    Button:SetAttribute("Type", _type)
    Button:SetAttribute("Style", Properties.StyleID)

    self.Objects[string.lower(Title)] = Button
    self.ApplyStyle(self, Button)
    Button.Parent = ParentReference
    return Button, Button.LayoutOrder
end

return Button