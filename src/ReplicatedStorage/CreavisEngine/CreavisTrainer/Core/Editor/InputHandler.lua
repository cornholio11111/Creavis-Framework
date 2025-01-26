local InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler.Initialize(EdtiorReference)
    local self = setmetatable({}, InputHandler)
    self.EdtiorReference = EdtiorReference
    
    self:Connect()
    return self
end

function InputHandler:Connect()
    
end

return InputHandler