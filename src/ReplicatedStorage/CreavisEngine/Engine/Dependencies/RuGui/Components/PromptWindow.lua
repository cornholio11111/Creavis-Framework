local Widget = require(script.Parent.Base.Widget)

local PromptWindow = {}

local DefaultPosition = UDim2.new(.5, 0, .5, 0)

function PromptWindow.new(self, Title:string, Properties:{Size:UDim2, Position:string?, HeaderTitle:string?})
    local PromptContext = {}

    PromptContext.Window = Widget.new(self, Title, {Position = DefaultPosition, Size = Properties.Size, CanDock = false, HeaderTitle = Properties.HeaderTitle})



    return PromptContext
end

return PromptWindow