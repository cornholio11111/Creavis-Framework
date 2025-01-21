--[[
	Event Module By: @daisyesta101 (MrShowerMan)
]]

--[[
    
]]

local RunService = game:GetService("RunService")

local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

local Event = {}

local RemoteEvent = nil
local RemoteFunction = nil
local BindableEvent = nil
local BindableFunction = nil

if isServer then
	local function create(t)
		local new = Instance.new(t)
		new.Parent = script
		new.Name = t
		return new
	end
	RemoteEvent = create("RemoteEvent")
	RemoteFunction = create("RemoteFunction")
	BindableEvent = create("BindableEvent")
	BindableFunction = create("BindableFunction")
elseif isClient then
	RemoteEvent = script:WaitForChild("RemoteEvent")
	RemoteFunction = script:WaitForChild("RemoteFunction")
	BindableEvent = script:WaitForChild("BindableEvent")
	BindableFunction = script:WaitForChild("BindableFunction")
end

function call(callback)
	return function(t, name)
		if t[name] then
			return t[name]
		end
		
		t[name] = callback(name)
		
		return t[name]
	end
end		

Event.Remote = setmetatable({}, { __call = call(function(name)
	if isServer then
		return {
			OnServerEvent = { 
				Connect = function(_, callback)
					return RemoteEvent.OnServerEvent:Connect(function(player, event, ...)
						if event == name then
							callback(player, ...)
						end
					end)
				end
			},
			FireAllClients = function(_, ...)
				RemoteEvent:FireAllClients(name, ...)
			end,
			FireClient = function(_, client, ...)
				RemoteEvent:FireClient(name, client, ...)
			end,
		}
	elseif isClient then
		return {
			OnClientEvent = { 
				Connect = function(_, callback)
					return RemoteEvent.OnClientEvent:Connect(function(event, ...)
						if event == name then
							callback(...)
						end
					end)
				end
			},
			FireServer	 = function(_, ...)
				RemoteEvent:FireServer(name, ...)
			end,
		}
	end
end) })

Event.Bindable = setmetatable({}, { __call = call(function(name)
	return {
		Event = { 
			Connect = function(_, callback)
				BindableEvent.Event:Connect(function(event, ...)
					if event == name then
						callback(...)
					end
				end)
			end
		},
		Fire = function(_, ...)
			BindableEvent:Fire(name, ...)
		end,
	}
end) })

if isServer then
	RemoteFunction.OnServerInvoke = function(player, name, ...)
		return Event.RemoteFunction(name).OnServerInvoke(...)
	end
elseif isClient then
	RemoteFunction.OnClientInvoke = function(name, ...)
		return Event.RemoteFunction(name).OnClientInvoke(...)
	end
end

Event.RemoteFunction = setmetatable({}, { __call = call(function(name)
	if isServer then
		return {
			OnServerInvoke = function(...) end,
			InvokeClient = function(_, ...)
				return RemoteFunction:InvokeClient(name, ...)
			end,
		}
	elseif isClient then
		return {
			OnClientInvoke = function(...) end,
			InvokeServer = function(_, ...)
				return RemoteFunction:InvokeServer(name, ...)
			end,
		}
	end
end) })

BindableFunction.OnInvoke = function(name, ...)
	return Event.BindableFunction(name).OnInvoke(...)
end

Event.BindableFunction = setmetatable({}, { __call = call(function(name)
	return {
		OnInvoke = function() end,
		Invoke = function(_, ...)
			return BindableFunction:Invoke(name, ...)
		end
	}
end) })

return Event