local Players = game:GetService("Players")
local UserInterface = script.Parent.Parent.UserInterface
local StudioInterfaceModule, StudioStyleSheet = UserInterface:WaitForChild("Studio"), UserInterface:WaitForChild("StudioStyleSheet")

local Editor = {}
Editor.__index = Editor

local Dependencies = {
    client = {
        InputHandler = script.InputHandler;
        Freecam = script.Freecam;
        MovementTools = script.MovementTools;

    };

    server = {

    };

    shared = {

    };
}

local function AddArrays(array1, array2)
    local result = {}
    table.move(array1, 1, #array1, 1, result)
    table.move(array2, 1, #array2, #result + 1, result)
    return result
end

local function RequireDependencies(self, AuthoritySide)
    local fullDependencies = Dependencies[AuthoritySide]

    print(fullDependencies)

    for index, Dependency in pairs(fullDependencies) do
        print(index)
        local RequiredDependency = require(Dependency)
        print(Dependency)
        self.Dependencies[AuthoritySide][Dependency.Name] = RequiredDependency
    end
    
    print(self.Dependencies)
end

function Editor.Initialize(CreavisEngine)
    local self = setmetatable({}, Editor)
    self.CreavisEngine = CreavisEngine

    self.EditorActive = false

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

    return self
end

function Editor:ConnectServer()
    
end

function Editor:ConnectClient()
    print(self.Dependencies)

    local RuGuiAdaptor = self.CreavisEngine.Dependencies.Engine.RuGuiAdaptor

    local StudioUI = RuGuiAdaptor.LoadModuleUI(StudioInterfaceModule, Players.LocalPlayer.PlayerGui, {Title = 'Studio'})
    StudioUI.Context:SetStyleSheet(require(StudioStyleSheet))

    task.wait()

    self.Dependencies.client.Freecam:EnableFreecam()
    self.Dependencies.client.MovementTools.Initialize(self)
    self.Dependencies.client.InputHandler.Initialize(self)
end

return Editor