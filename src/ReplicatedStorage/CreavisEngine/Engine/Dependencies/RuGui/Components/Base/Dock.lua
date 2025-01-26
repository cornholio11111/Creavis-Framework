local Dock = {}

function Dock.new(self, Title:string, Properties:{Position:UDim2, Size:UDim2, Dockable:boolean?, StyleID:string?})
    local Dock = Instance.new("Frame", self.RuGuiData.WindowBaseFrame.Docks)
    Dock.Name = Title
    Dock.LayoutOrder = #self.Docks + 1
    Dock.AnchorPoint = Vector2.new(.5, .5)

    Dock.BackgroundTransparency = 1

    Dock.Position = Properties.Position
    Dock.Size = Properties.Size

    Dock:SetAttribute("Dockable", Properties.Dockable) -- << If something can dock to this DockFrame
    Dock:SetAttribute("Type", "Dock")

    Dock:SetAttribute("Style", Properties.StyleID or "Dock")

    self.Docks[string.lower(Title)] = {Dock = Dock, Data = {Widgets = {};}} -- << EXAMPLE: {Name:string, LayoutOrder:number, Selected:boolean}

    -- local Tablist = self:CreateTabList(Dock.."Tablist", {Position = UDim2.new(-.9, 0, .5, 0), Size = UDim2.new(1, 0, 0, 20)}, Dock)

    self.Objects[string.lower(Title)] = Dock
    self.ApplyStyle(self, Dock)

    return Dock, Dock.LayoutOrder
end

return Dock