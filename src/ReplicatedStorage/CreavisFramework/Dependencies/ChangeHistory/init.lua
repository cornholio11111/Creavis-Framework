local EventHandler = require(script.Parent.EventHandler)

local ChangeHistory = {}
ChangeHistory.Mode = "Server"
ChangeHistory.History = {}

function ChangeHistory.Initialize(CreavisFramework)
    local self = setmetatable({}, { __index = ChangeHistory })
    self.CreavisFrameworkReference = CreavisFramework

    self:Connect()
    return self
end

function ChangeHistory:Connect()
    self:AddHistoryMarker("Change History Started", { }, false)

    local AddHistoryMarkerEvent = EventHandler:CreateRemoteEvent("AddHistoryMarker")
    local FindMarkerEvent = EventHandler:CreateRemoteEvent("FindMarker")
    local EditHistoryMarkerEvent = EventHandler:CreateRemoteEvent("EditHistoryMarker")
    local RemoveHistoryMarkerEvent = EventHandler:CreateRemoteEvent("RemoveHistoryMarker")
    local ClearHistoryMarkersEvent = EventHandler:CreateRemoteEvent("ClearHistoryMarkers")
    local GetHistoryEvent = EventHandler:CreateRemoteEvent("GetHistory")

    

    self:AddHistoryMarker("Change History Linked 2 Events", { "Created Remote Events for the Change History System" }, false)
end

-- // Markers

function ChangeHistory:FindMarker(MarkerFindContext: { RID: string?, TimeStamp: string?, MarkerName: string?, ContextHas: string? })
    for _, marker in ipairs(ChangeHistory.History) do
        if (not MarkerFindContext.RID or marker.RID == MarkerFindContext.RID)
            and (not MarkerFindContext.TimeStamp or marker.TimeStamp == MarkerFindContext.TimeStamp)
            and (not MarkerFindContext.MarkerName or marker.Name == MarkerFindContext.MarkerName)
            and (not MarkerFindContext.ContextHas or marker.Context[MarkerFindContext.ContextHas] ~= nil) then
            return marker
        end
    end
    return nil -- Marker not found
end

function ChangeHistory:AddHistoryMarker(MarkerName: string, MarkerContext: {}, Changable: boolean)
    local TimeStamp = os.date("%H:%M:%S.") .. string.sub(string.match(tostring(os.clock()), "%.(%d+)"), 1, 3)
    local MarkerRID = tostring(os.clock()) -- Generate a random 10-digit string for the RID

    local NewContext = {
        RID = MarkerRID;
        Name = MarkerName;
        TimeStamp = TimeStamp;
        Context = MarkerContext;
        Changable = Changable;
    }

    ChangeHistory.History[#ChangeHistory.History + 1] = NewContext
    return NewContext
end

function ChangeHistory:EditHistoryMarker(Index: number, MarkerContext: {}, Changable: boolean)
    local marker = ChangeHistory.History[Index]
    if marker and marker.Changable then
        marker.Context = MarkerContext
        marker.Changable = Changable
        return true -- Successfully edited
    else
        return false -- Editing not allowed
    end
end

function ChangeHistory:RemoveHistoryMarker(Index: number, Changable: boolean)
    local marker = ChangeHistory.History[Index]
    if marker and marker.Changable == Changable then
        table.remove(ChangeHistory.History, Index)
        return true -- Successfully removed
    else
        return false -- Removal not allowed
    end
end

-- // Array Management

function ChangeHistory:Clear()
    ChangeHistory.History = {}
end

-- // Pure Data Functions

function ChangeHistory.GetHistory()
    return ChangeHistory.History
end

return ChangeHistory