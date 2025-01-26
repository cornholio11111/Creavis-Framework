local UserInputService = game:GetService("UserInputService")
local InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler.Initialize(EditorReference)
    local self = setmetatable({}, InputHandler)
    self.EditorReference = EditorReference

    self.ActivatedKeys = {}
    self.KeyHistory = {}
    
    self:Connect()
    return self
end

function InputHandler:Connect()
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)

    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        
    end)
end

return InputHandler