local Button = require(script.Parent.Base.Button)
local List = require(script.Parent.Base.List)

local TabList = {}

function TabList.new(self, Title: string, Properties: { Position: UDim2, Size: UDim2, StyleID:string? }, ParentReference: UIBase)
    -- << uses a list to create a tab list using UI, that is interactable.

    -- << Use a context holder for each list, which allows to link?
    -- << :AddTab(Title:string, Properties: {}, MouseButton1ClickEvent)
    -- << :RemoveTab(Title:string)
    Properties.StyleID = Properties.StyleID or 'TabList'

    local TabListContext = {}

    TabListContext.ListBox = List.new(self, Title, Properties, ParentReference)
    
    -- Instance.new("Frame", ParentReference)
    -- TabListContext.ListBox.Position = Properties.Position --or GetBottomOfParent()
    -- TabListContext.ListBox.Size = Properties.Size or UDim2.new(1, 0, .05, 0)
    
    -- TabListContext.ListBox:SetAttribute("StyleID", Properties.StyleID)

    TabListContext.Tabs = {}

    function TabListContext.AddTab(TabTitle:string, TabProperties: {})
        local NewTabButton = Button.new(self, TabTitle, TabProperties, TabListContext)

        TabListContext.Tabs[TabTitle] = NewTabButton

        return NewTabButton, #TabListContext.Tabs
    end

    function TabListContext.RemoveTab(TabTitle:string)
        if TabListContext.Tabs[TabTitle] then
            TabListContext.Tabs[TabTitle] = nil
        end
    end

    return TabListContext
end

return TabList