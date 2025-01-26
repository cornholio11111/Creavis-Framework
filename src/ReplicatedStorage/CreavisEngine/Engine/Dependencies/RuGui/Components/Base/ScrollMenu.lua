local ScrollMenu = {}

function ScrollMenu.new(self, Title:string, Properties:{UseListLayout:boolean?, UseGridLayout:boolean?, LayoutPadding:UDim2?, SortOrder:Enum.SortOrder?, Position:UDim2, Size:UDim2}, ParentID:string)
    ParentID = ParentID or "None"
    Properties.StyleID = Properties.StyleID or "None"

    if Properties.UseGridLayout or Properties.UseListLayout then
        Properties.UIPadding = Properties.UIPadding or UDim.new(.25, 0)
        Properties.CellPadding = Properties.CellPadding or UDim2.new(.25, 0, .25, 0)
    end

    if ParentID == "None" then
        error("Widget Parent ID wasn't passed")
    elseif not self.Objects[string.lower(ParentID)] then
        print(self.Objects)
        error(ParentID.." Not Found in self.Objects in Rugui!")
    end

    local ParentReference = self.Objects[string.lower(ParentID)]

    local ScrollingFrame = Instance.new("ScrollingFrame", ParentReference)
    ScrollingFrame.Name = Title
    ScrollingFrame.LayoutOrder = #ParentReference:GetChildren() + 1
    ScrollingFrame.AnchorPoint = Vector2.new(.5, .5)
    ScrollingFrame:SetAttribute("Type", "ScrollFrame")
    ScrollingFrame:SetAttribute("Style", "ScrollFrame")
    
    if Properties.UseListLayout then
        local ListLayout = Instance.new("UIListLayout", ScrollingFrame)
        ListLayout.Padding = Properties.LayoutPadding
        ListLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder
    elseif Properties.UseGridLayout then
        local GridLayout = Instance.new("UIGridLayout", ScrollingFrame)
        GridLayout.CellPadding = Properties.LayoutPadding
        GridLayout.SortOrder = Properties.SortOrder or Enum.SortOrder.LayoutOrder
    end

    return ScrollingFrame, ScrollingFrame.LayoutOrder
end

return ScrollMenu