local TweenService = game:GetService("TweenService")
local Button = require(script.Parent.Base.Button)
local TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local Dropdown = {}

local openDropdown = false

function Dropdown.new(self, Title:string, Properties: { Position: UDim2, Size: UDim2, Text: string?, IsImage: boolean?, Image: string?}, Parent: UIBase)
    if not Parent then error("Parent reference is required to create a dropdown.") end

    local DropdownContext = {}

    DropdownContext.MainButton = Button.new(self, Title, {
        Position = Properties.Position,
        Size = Properties.Size,
        Text = Properties.Text,
        IsImage = Properties.IsImage or false,
        Image = Properties.Image
    }, Parent)

    DropdownContext.DropdownBox = Instance.new("Frame", DropdownContext.MainButton)
    DropdownContext.DropdownBox.Name = "Options"
    DropdownContext.DropdownBox.Size = UDim2.new(1, 0, 9, 0)
    DropdownContext.DropdownBox.AnchorPoint = Vector2.new(.5, .5)
    DropdownContext.DropdownBox.Position = UDim2.new(0.5, 0, 6, 0)
    DropdownContext.DropdownBox.BackgroundTransparency = 1
    DropdownContext.DropdownBox.Visible = false
    DropdownContext.DropdownBox.BorderSizePixel = 0

    DropdownContext.ListLayout = Instance.new("UIListLayout", DropdownContext.DropdownBox)
    DropdownContext.ListLayout.FillDirection = Enum.FillDirection.Vertical
    DropdownContext.ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropdownContext.ListLayout.Padding = UDim.new(0, 5)

    DropdownContext.DropdownBox:SetAttribute("Style", 'Widget')

    self.Objects[string.lower(Title.."List")] = DropdownContext.DropdownBox
    self.ApplyStyle(self, DropdownContext.DropdownBox)

    DropdownContext.MainButton.MouseButton1Click:Connect(function()
        if openDropdown and openDropdown ~= DropdownContext then
            openDropdown.DropdownBox.Visible = false
            local tweenOut = TweenService:Create(openDropdown.DropdownBox, TweenInfo, {
                BackgroundTransparency = 1,
            })
            tweenOut:Play()
        end

        if DropdownContext.DropdownBox.Visible then
            local tweenOut = TweenService:Create(DropdownContext.DropdownBox, TweenInfo, {
                BackgroundTransparency = 1,
            })
            tweenOut:Play()
            DropdownContext.DropdownBox.Visible = false
        else
            local tweenIn = TweenService:Create(DropdownContext.DropdownBox, TweenInfo, {
                BackgroundTransparency = 0,
            })
            tweenIn:Play()
            DropdownContext.DropdownBox.Visible = true
        end

        openDropdown = DropdownContext
    end)

    function DropdownContext.AddOption(OptionsData, Parent)
        if OptionsData.Type == 'Seperator' then return end

        local OptionButton = Button.new(self, OptionsData.Name, {
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 0, 15),
            BorderSizePixel = 0,
            TextScaled = true,
            Text = OptionsData.Properties.Text,
            BackgroundTransparency = 1,
            StyleID = OptionsData.Properties.StyleID
        }, Parent)

        OptionButton.LayoutOrder = OptionsData.Priority

        OptionButton.MouseButton1Click:Connect(function()
            DropdownContext.DropdownBox.Visible = false
        end)
    end

    return DropdownContext
end

return Dropdown