-- This holds a button with an image on top & text under it, also could have a dropbox maybe???
local List = require(script.Parent.Base.List)
local Button = require(script.Parent.Base.Button)

local StackedButton = {}

function StackedButton.new(self, Title:string, Properties:{Size:UDim2, Position:UDim2, Image:string, Text:string?, TextScaled:boolean?}, Parent: UIBase)
    if not Properties.Text then Properties.Text = Title end
    if not Properties.Position then Properties.Position = UDim2.new(.1, 0, .1, 0) end
    if not Properties.TextScaled then Properties.TextScaled = false end

    local StackedButtonContext = {}

    StackedButtonContext.BaseList = List.new(self, Title, {
        Position = Properties.Position,
        Size = Properties.Size,
        FillDirection = Enum.FillDirection.Vertical,
        UIPadding = UDim.new(.001, 0)
    }, Parent)

    StackedButtonContext.ImageButton = Button.new(self, "Image"..Title, {
        Position = Properties.Position,
        Size = UDim2.new(1, 0, .7, 0),
        Text = "",
        IsImage = true,
        Image = Properties.Image,
    }, StackedButtonContext.BaseList)

    StackedButtonContext.TextButton = Button.new(self, "Text"..Title, {
        Position = Properties.Position,
        Size = UDim2.new(1, 0, .25, 0),
        Text = Properties.Text,
        IsImage = false,
        TextScaled = Properties.TextScaled,
        Image = Properties.Image
    }, StackedButtonContext.BaseList)

    return StackedButtonContext
end

return StackedButton