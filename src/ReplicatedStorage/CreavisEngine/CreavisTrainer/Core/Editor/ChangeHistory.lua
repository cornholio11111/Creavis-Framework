local ChangeHistory = {}
ChangeHistory.__index = ChangeHistory

local MAX_HISTORY_SIZE = 2 * 1024 * 1024 * 1024 -- 2GB OF STORING CHANGES | USES RAM BTW
local currentHistorySize = 0

function ChangeHistory.Initialize(EditorReference)
    local self = setmetatable({}, ChangeHistory)
    self.EditorReference = EditorReference

    self.history = {}
    self.currentIndex = 0

    local authoritySide = EditorReference.CreavisEngine.AuthoritySide
    if authoritySide == "client" then
        self:ConnectClient()
    elseif authoritySide == "server" then
        self:ConnectServer()
    else
        warn("Unknown authority side: " .. tostring(authoritySide))
    end

    return self
end

function ChangeHistory:ConnectClient()
    print("Launched change history client.")
end

function ChangeHistory:ConnectServer()
    print("Launched change history server.")
end

local function estimateChangeSize(change)
    local serialized = game:GetService("HttpService"):JSONEncode(change)
    return #serialized
end

function ChangeHistory:TrimHistory(trimCount)
    for _ = 1, trimCount + 2 do
        if #self.history > 0 then
            local oldestChange = table.remove(self.history, 1)
            local oldestChangeSize = estimateChangeSize(oldestChange)
            currentHistorySize = currentHistorySize - oldestChangeSize
        else
            break
        end
    end
end

function ChangeHistory:RecordChange(description, applyChange, revertChange)
    while #self.history > self.currentIndex do
        table.remove(self.history)
    end

    local newChange = {
        description = description,
        apply = applyChange,
        revert = revertChange,
    }

    local changeSize = estimateChangeSize(newChange)

    if currentHistorySize + changeSize <= MAX_HISTORY_SIZE then
        table.insert(self.history, newChange)
        currentHistorySize = currentHistorySize + changeSize
        self.currentIndex = self.currentIndex + 1
    else
        local trimCount = math.ceil((currentHistorySize + changeSize - MAX_HISTORY_SIZE) / (changeSize / #self.history))
        self:TrimHistory(trimCount)

        table.insert(self.history, newChange)
        currentHistorySize = currentHistorySize + changeSize
        self.currentIndex = #self.history
    end
end

function ChangeHistory:Undo()
    if self.currentIndex > 0 then
        local change = self.history[self.currentIndex]
        if change and change.revert then
            change.revert()
            self.currentIndex = self.currentIndex - 1
            print("Undo: " .. change.description)
        end
    else
        print("No changes to undo.")
    end
end

function ChangeHistory:Redo()
    if self.currentIndex < #self.history then
        local change = self.history[self.currentIndex + 1]
        if change and change.apply then
            change.apply()
            self.currentIndex = self.currentIndex + 1
            print("Redo: " .. change.description)
        end
    else
        print("No changes to redo.")
    end
end

function ChangeHistory:ResetHistory()
    self.history = {}
    self.currentIndex = 0
    currentHistorySize = 0
    print("History reset.")
end

return ChangeHistory