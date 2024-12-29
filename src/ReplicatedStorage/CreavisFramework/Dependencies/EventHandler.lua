-- local EnumsHandler = require(script.Parent.EnumsHandler)
-- local EnumList = EnumsHandler.EnumList

local EventHandler = {}
EventHandler.__index = EventHandler

EventHandler.Configurations = {
    TickSpeed = .002;
}

EventHandler._Backend = {
    TimeSinceLastTick = 0;
}

EventHandler.Events = {
    Public = {};
    Protected = {};
    Private = {};

    --[[ 
        Example Event:
    
        {RID = random.hex(); Privacy = EnumsList.Privacy}

    ]]--
}

function EventHandler.Initialize(CreavisFramework)
    local self = setmetatable{{}, EventHandler}
    self.CreavisFrameworkReference = CreavisFramework
    
    self.Coroutines = {}

    self.UpdateQueue = {} -- // What should be fired in a list format
    -- // {Priority : 0, Event RID, Privacy, DataSent}
    self.EventHistory = {}

    self:Connect()
    return self
end

function EventHandler:Connect()
    local function ConnectCoroutine()
        self:TickUpdate()
    end

    self.Coroutines["ConnectThread"] = coroutine.create(ConnectCoroutine)

    coroutine.close(self.Coroutines["ConnectThread"])
end

function EventHandler:TickUpdate()
    while task.wait(self.Configurations.TickSpeed) do
        self._Backend.TimeSinceLastTick = DateTime.now()

        -- // IDFK

    end
end

return EventHandler