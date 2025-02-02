local UserInputService = game:GetService("UserInputService")

local InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler.Initialize(EditorReference)
    local self = setmetatable({}, InputHandler)
    self.EditorReference = EditorReference

    self.ActivatedKeys = {} -- Tracks currently pressed keys
    self.KeyHistory = {} -- Stores input history for potential undo/redo
    self.KeyBindings = {} -- Stores keybind functions

    self:Connect()
    return self
end

-- Bind a key to a function
function InputHandler:BindKey(keyCode, callback)
    local keyCodeName = keyCode.Name
    self.KeyBindings[keyCodeName] = callback

    --  ReplicatedStorage.CreavisEngine.CreavisTrainer.Core.Editor.InputHandler:20: attempt to index nil with EnumItem  -  Client - InputHandler:21
end

function InputHandler:Connect()
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end -- Ignore inputs processed by the game

        local keyCode = input.KeyCode
        if keyCode ~= Enum.KeyCode.Unknown then
            self.ActivatedKeys[keyCode] = true
            table.insert(self.KeyHistory, keyCode)

            -- Execute bound function if exists
            if self.KeyBindings[keyCode] then
                self.KeyBindings[keyCode]()
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end

        local keyCode = input.KeyCode
        if self.ActivatedKeys[keyCode] then
            self.ActivatedKeys[keyCode] = nil
        end
    end)
end

return InputHandler