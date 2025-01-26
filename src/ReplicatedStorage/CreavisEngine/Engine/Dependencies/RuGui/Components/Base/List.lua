local List = {}

function List.new(self, Title: string, Properties: {Position: UDim2?, FillDirection: Enum.FillDirection?, Size: UDim2?, AutoAligned: boolean?, UIPadding: UDim?, StyleID: string?, LayoutType: string?}, ParentReference: UIBase)
    Properties.StyleID = Properties.StyleID or "HorizontalList"
    Properties.UIPadding = Properties.UIPadding or UDim.new(0.25, 0)
    Properties.LayoutType = Properties.LayoutType or "List"  -- Default layout type

    local HorizontalList = Instance.new("Frame")
    HorizontalList.Name = Title
    HorizontalList.AnchorPoint = Vector2.new(0.5, 0.5)
    HorizontalList:SetAttribute("Type", "HorizontalList")
    HorizontalList:SetAttribute("Style", Properties.StyleID)
    HorizontalList.LayoutOrder = #ParentReference:GetChildren() + 1

    local Layout

    -- Switch between different layout types based on the specified layout type
    if Properties.LayoutType == "List" then
        Layout = Instance.new("UIListLayout", HorizontalList)
        Layout.FillDirection = Properties.FillDirection or Enum.FillDirection.Vertical
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = Properties.UIPadding
    elseif Properties.LayoutType == "Grid" then
        Layout = Instance.new("UIGridLayout", HorizontalList)
        Layout.CellSize = UDim2.new(0, 100, 0, 100)  -- Default grid cell size
        Layout.FillDirection = Properties.FillDirection or Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Layout.VerticalAlignment = Enum.VerticalAlignment.Center
        Layout.Padding = Properties.UIPadding
    elseif Properties.LayoutType == "Page" then
        Layout = Instance.new("UIPageLayout", HorizontalList)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = Properties.UIPadding
    end

    -- If not AutoAligned, set size and position explicitly
    if not Properties.AutoAligned then
        HorizontalList.Size = Properties.Size or UDim2.new(1, 0, 0, 30)
        HorizontalList.Position = Properties.Position or UDim2.new(0.5, 0, 0.5, 0)
    end

    self.Objects[string.lower(Title)] = HorizontalList
    self.ApplyStyle(self, HorizontalList)
    HorizontalList.Parent = ParentReference

    return {List = HorizontalList, Index = HorizontalList.LayoutOrder, Layout = Layout}
end

return List