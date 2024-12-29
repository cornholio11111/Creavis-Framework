-- stores the change history in this framework/engine

local ChangeHistory = {}
ChangeHistory.History = {}

function ChangeHistory.Initialize(CreavisFramework)
    local self = setmetatable({}, {__index = ChangeHistory})
    self.CreavisFrameworkReference = CreavisFramework

    self:Connect()
    return self
end

function ChangeHistory:Connect()
   self:AddHistoryMarker("Framework Started", {InitGame = "InitGame"}, false)
end

-- // Markers

function ChangeHistory:FindMarker(MarkerFindContext:{RID:string?, TimeStamp:string?, MarkerName:string?, ContextHas:string?})
    
end

function ChangeHistory:AddHistoryMarker(MarkerName:string, MarkerContext:{}, Changable:boolean)
    local TimeStamp = os.date("%H:%M:%S." .. string.sub(string.match(tostring(os.clock()), "%.(%d+)"), 1, 3))
    local MarkerRID = math.randomseed(os.time())

    local NewContext = {
        RID = MarkerRID;
        Name = MarkerName;
        TimeStamp = TimeStamp;

        Context = MarkerContext;
    }

    ChangeHistory.History[ChangeHistory.History + 1] =  NewContext
end

function ChangeHistory:EditHistoryMarker(Index:number, MarkerContext:{}, Changable:boolean)
    
end

function ChangeHistory:RemoveHistoryMarker(Index:number, Changeable:boolean)
    
end

-- // Array Management

function ChangeHistory:Clear()
    
end

-- // Pure Data Functions

function ChangeHistory.GetHistory()
    return ChangeHistory.History
end

return ChangeHistory