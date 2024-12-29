local EventHandler = {}
EventHandler.Mode = "Any"

-- Configuration
EventHandler.Configurations = {
    DefaultTimeout = 10 -- Timeout for waiting on remote function calls
}

-- Stores for remote events and functions
EventHandler.RemoteEvents = {}
EventHandler.RemoteFunctions = {}
EventHandler.BindableEvents = {}
EventHandler.BindableFunctions = {}

-- Initialization
function EventHandler.Initialize(CreavisFramework, isServer)
    local self = setmetatable({}, { __index = EventHandler })
    self.CreavisFrameworkReference = CreavisFramework
    self.IsServer = isServer

    return self
end

-- Create a RemoteEvent or RemoteFunction
function EventHandler:CreateRemoteEvent(name)
    if self.RemoteEvents[name] then
        warn("RemoteEvent already exists:", name)
        return
    end

    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = name
    if self.IsServer then
        remoteEvent.Parent = game.ReplicatedStorage -- Server stores the RemoteEvent
    end
    self.RemoteEvents[name] = remoteEvent

    return remoteEvent
end

-- Create a RemoteFunction
function EventHandler:CreateRemoteFunction(name)
    if self.RemoteFunctions[name] then
        warn("RemoteFunction already exists:", name)
        return
    end

    local remoteFunction = Instance.new("RemoteFunction")
    remoteFunction.Name = name
    if self.IsServer then
        remoteFunction.Parent = game.ReplicatedStorage -- Server stores the RemoteFunction
    end
    self.RemoteFunctions[name] = remoteFunction

    return remoteFunction
end

-- Create a BindableEvent (local event handling)
function EventHandler:CreateBindableEvent(name)
    if self.BindableEvents[name] then
        warn("BindableEvent already exists:", name)
        return
    end

    local bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Name = name
    self.BindableEvents[name] = bindableEvent

    return bindableEvent
end

-- Create a BindableFunction (local function handling)
function EventHandler:CreateBindableFunction(name)
    if self.BindableFunctions[name] then
        warn("BindableFunction already exists:", name)
        return
    end

    local bindableFunction = Instance.new("BindableFunction")
    bindableFunction.Name = name
    self.BindableFunctions[name] = bindableFunction

    return bindableFunction
end

-- Fire a RemoteEvent (for server-to-client or client-to-server)
function EventHandler:FireRemoteEvent(name, data)
    local remoteEvent = self.RemoteEvents[name]
    if remoteEvent then
        if self.IsServer then
            remoteEvent:FireAllClients(data) -- Fire to all clients (server side)
        else
            remoteEvent:FireServer(data) -- Fire to server (client side)
        end
    else
        warn("RemoteEvent not found:", name)
    end
end

-- Call a RemoteFunction (for server-client communication)
function EventHandler:CallRemoteFunction(name, data)
    local remoteFunction = self.RemoteFunctions[name]
    if remoteFunction then
        if self.IsServer then
            return remoteFunction:InvokeClient(data) -- Call on specific client (server side)
        else
            return remoteFunction:InvokeServer(data) -- Call on server (client side)
        end
    else
        warn("RemoteFunction not found:", name)
        return nil
    end
end

-- Fire a BindableEvent (local event handling)
function EventHandler:FireBindableEvent(name, data)
    local bindableEvent = self.BindableEvents[name]
    if bindableEvent then
        bindableEvent:Fire(data)
    else
        warn("BindableEvent not found:", name)
    end
end

-- Call a BindableFunction (local function handling)
function EventHandler:CallBindableFunction(name, data)
    local bindableFunction = self.BindableFunctions[name]
    if bindableFunction then
        return bindableFunction:Invoke(data)
    else
        warn("BindableFunction not found:", name)
        return nil
    end
end

-- Watch a RemoteEvent (for client-side handling or server-side watching)
function EventHandler:WatchRemoteEvent(name, callback)
    local remoteEvent = self.RemoteEvents[name]
    if remoteEvent then
        remoteEvent.OnClientEvent:Connect(callback) -- Watch for remote events
    else
        warn("RemoteEvent not found:", name)
    end
end

-- Watch a RemoteFunction (for client-side handling or server-side watching)
function EventHandler:WatchRemoteFunction(name, callback)
    local remoteFunction = self.RemoteFunctions[name]
    if remoteFunction then
        remoteFunction.OnServerInvoke = callback -- Watch for remote function calls
    else
        warn("RemoteFunction not found:", name)
    end
end

-- Delete an Event or Function
function EventHandler:DeleteEvent(name)
    if self.RemoteEvents[name] then
        self.RemoteEvents[name]:Destroy()
        self.RemoteEvents[name] = nil
    elseif self.BindableEvents[name] then
        self.BindableEvents[name]:Destroy()
        self.BindableEvents[name] = nil
    else
        warn("Event or function not found:", name)
    end
end

-- Cleanup all events and functions
function EventHandler:Clear()
    for _, remoteEvent in pairs(self.RemoteEvents) do
        remoteEvent:Destroy()
    end
    self.RemoteEvents = {}

    for _, bindableEvent in pairs(self.BindableEvents) do
        bindableEvent:Destroy()
    end
    self.BindableEvents = {}

    for _, remoteFunction in pairs(self.RemoteFunctions) do
        remoteFunction:Destroy()
    end
    self.RemoteFunctions = {}

    for _, bindableFunction in pairs(self.BindableFunctions) do
        bindableFunction:Destroy()
    end
    self.BindableFunctions = {}
end

return EventHandler