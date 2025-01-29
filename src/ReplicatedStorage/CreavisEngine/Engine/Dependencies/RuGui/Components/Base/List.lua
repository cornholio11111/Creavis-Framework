local List = {}

function List.new(self, Title: string, 
    Properties: {Position: UDim2?, FillDirection: Enum.FillDirection?, Size: UDim2?, AutoAligned: boolean?,  UIPadding: UDim?, StyleID: string?, LayoutType: string?, CellSize:UDim2?, VerticalAlignment:Enum.VerticalAlignment?, HorizontalAlignment:Enum.HorizontalAlignment?,  ZIndex:number?}, 
    ParentReference: Instance, extra)
    if not Properties.StyleID then Properties.StyleID = "HorizontalList" end
    if not Properties.LayoutType then Properties.LayoutType = "List" end
    if not Properties.UIPadding then Properties.UIPadding = UDim.new(0.25, 0) end
    if not Properties.CellSize then Properties.CellSize = UDim2.new(.003, 0, .8, 0) end
    if not Properties.HorizontalAlignment then Properties.HorizontalAlignment = Enum.HorizontalAlignment.Left end
    if not Properties.VerticalAlignment then Properties.VerticalAlignment = Enum.VerticalAlignment.Center end
    if not Properties.ZIndex then Properties.ZIndex = 5 end

    -- << #ParentReference:GetChildren() + 1

    local HorizontalList = Instance.new("Frame")
    HorizontalList.Name = Title
    HorizontalList.AnchorPoint = Vector2.new(0.5, 0.5)

    HorizontalList:SetAttribute("Type", "HorizontalList")
    HorizontalList:SetAttribute("Style", Properties.StyleID)

    HorizontalList.LayoutOrder = Properties.ZIndex
    HorizontalList.ZIndex = Properties.ZIndex

    local Layout

    -- Switch between different layout types based on the specified layout type
    if Properties.LayoutType == "List" then
        Layout = Instance.new("UIListLayout", HorizontalList)
        Layout.FillDirection = Properties.FillDirection or Enum.FillDirection.Vertical
        Layout.HorizontalAlignment = Properties.HorizontalAlignment
        Layout.VerticalAlignment = Properties.VerticalAlignment
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = Properties.UIPadding
    elseif Properties.LayoutType == "Grid" then
        Layout = Instance.new("UIGridLayout", HorizontalList)
        Layout.CellSize = Properties.CellSize
        Layout.FillDirection = Properties.FillDirection or Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment = Properties.HorizontalAlignment
        Layout.VerticalAlignment = Properties.VerticalAlignment
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

    return HorizontalList, Layout, HorizontalList.LayoutOrder
end

return List