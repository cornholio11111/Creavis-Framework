local Frame = {}

function Frame.new(self, Title, Properties:{Position:UDim2, Size:UDim2, StyleID:string?, ZIndex:number?}, WidgetReference:UIBase)
    if not Properties.StyleID then Properties.StyleID = "UIFrame" end
    if not Properties.ZIndex then Properties.ZIndex = 200 end

    local Frame = Instance.new("Frame")
    Frame.Name = Title
    Frame.LayoutOrder = #WidgetReference:GetChildren() + 1
    Frame.AnchorPoint = Vector2.new(.5, .5)
    Frame:SetAttribute("Type", "UIFrame")
    Frame:SetAttribute("Style", Properties.StyleID)

    Frame.Position = Properties.Position
    Frame.Size = Properties.Size

    Frame.Parent = WidgetReference

    self.Objects[string.lower(Title)] = Frame
    self.ApplyStyle(self, Frame)
    return Frame, Frame.LayoutOrder
end

return Frame