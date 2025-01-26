local Menu = {}

function Menu.new(self, Title:string, Properties:{UseListLayout:boolean?, UIPadding:UDim?, CellPadding:UDim2?, SortOrder:Enum.SortOrder?, Position:UDim2, Size:UDim2}, WidgetID:string)
    WidgetID = WidgetID or "None"
    Properties.StyleID = Properties.StyleID or "None"
    Properties.UIPadding = Properties.UIPadding or UDim.new(.25, 0)
    Properties.CellPadding = Properties.CellPadding or UDim2.new(.25, 0, .25, 0)

    if WidgetID == "None" then
        error("Widget Parent ID wasn't passed")
    elseif not self.Widgets[string.lower(WidgetID)] then
        print(self.Widgets)
        error("Widget Not Found in self.Widgets in Rugui!")
    end

    local WidgetReference = self.Widgets[string.lower(WidgetID)]

    local Menu = Instance.new("Frame", WidgetReference)
    Menu.Name = Title
    Menu.LayoutOrder = #WidgetReference:GetChildren() + 1
    Menu.AnchorPoint = Vector2.new(.5, .5)
    Menu:SetAttribute("Type", "UIMenu")
    Menu:SetAttribute("Style", "UIMenu")

    Menu.Position = Properties.Position
    Menu.Size = Properties.Size

    local SortLayout

    if Properties.UseListLayout == true then
        SortLayout = Instance.new("UIListLayout")

        SortLayout.Padding = Properties.UIPadding
    else
        SortLayout = Instance.new("UIGridLayout")

        SortLayout.CellPadding = Properties.CellPadding
    end

    SortLayout.Name = "Layout"
    SortLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder
    self.Objects[string.lower(Title)] = Menu
    self.ApplyStyle(self, SortLayout)
    return Menu, Menu.LayoutOrder
end

return Menu