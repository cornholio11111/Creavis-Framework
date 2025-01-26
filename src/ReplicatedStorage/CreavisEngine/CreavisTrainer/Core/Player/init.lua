-- << Normal loaded things for the Engine & Trainer

local Player = {}
Player.__index = Player

local Dependencies = {
    client = {

    };

    server = {

    };

    shared = {

    };
}

local function RequireDependencies(self, AuthoritySide)
    local fullDependencies = Dependencies[AuthoritySide]

    for index, Dependency in pairs(fullDependencies) do
        local RequiredDependency = require(Dependency)

        self.Dependencies[AuthoritySide][Dependency.Name] = RequiredDependency
    end
end

function Player.Initialize(CreavisEngine)
    local self = setmetatable({}, Player)
    self.CreavisEngine = CreavisEngine

    self.Dependencies = {
        client = {};
        server = {};
        shared = {};
    }
    
    RequireDependencies(self, CreavisEngine.AuthoritySide)
    RequireDependencies(self, "shared")

    if CreavisEngine.AuthoritySide == "client" then
        self:ConnectClient()
    end

    if CreavisEngine.AuthoritySide == "server" then
        self:ConnectServer()
    end
end

function Player:ConnectClient()
    
end

function Player:ConnectServer()
    
end

return Player