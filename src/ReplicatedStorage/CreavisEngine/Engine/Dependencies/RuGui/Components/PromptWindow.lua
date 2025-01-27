local Widget = require(script.Parent.Base.Widget)
local Resize = require(script.Parent.Parent.Extensions.Resize)

local PromptWindow = {}

local DefaultPosition = UDim2.new(.5, 0, .5, 0)

function PromptWindow.new(self, Title:string, Properties:{Size:UDim2, Position:string?, HeaderTitle:string?})
    if not Properties.Position then Properties.Position = DefaultPosition end
    
    local PromptContext = {}

    PromptContext.Window = Widget.new(self, Title, {Position = DefaultPosition, Size = Properties.Size, CanDock = false, HeaderTitle = Properties.HeaderTitle})
    PromptWindow.WindowResizeContext = Resize.new(self, PromptWindow.Window) -- << Adds ResizeBars to the window!!

    return PromptContext
end

return PromptWindow