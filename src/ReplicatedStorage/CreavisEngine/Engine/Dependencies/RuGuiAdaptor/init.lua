local Players = game:GetService("Players")
local RuGui = require(script.Parent.RuGui)

local RuGuiAdaptor = {}
RuGuiAdaptor.__index = RuGuiAdaptor

local Objects = {}

function CreatePacket(Context, ObjectData)
    local Parent = nil

    if ObjectData.Type == "Widget" then
        
    end

    if ObjectData.Type == "Dock" then
        
    end

    if ObjectData.Type == "Button" then
        
    end

    if ObjectData.Type == "Menu" then
        
    end

    if ObjectData.Dock then
        Parent = ObjectData.Dock
    end

    if ObjectData.Parent then
        Parent = string.lower(ObjectData.Parent)
        local reference = Context.Objects[Parent]
        if not reference then
            reference = table.find(Context.Objects, Parent)
        end

        if reference then
            Parent = reference
        else
            print("Warning: Parent not found for " .. ObjectData.Name)
        end
    end

    return {ObjectData.Name, ObjectData.Properties, Parent}
end

function RuGuiAdaptor.LoadModuleUI(ModuleReference: ModuleScript | string, Parent: any, Configuration: {Title: string?})
    if typeof(ModuleReference) == "string" then
        ModuleReference = script:FindFirstChild(ModuleReference) or error("Module not found")
    end

    if not Parent then
        error(".LoadModuleUI() failed to create UI, Parent wasn't sent.")
    end

    Configuration.Title = Configuration.Title or ModuleReference.Name

    local RequiredModule = require(ModuleReference)

    local NewWindow
    local Context

    if RequiredModule then
        NewWindow = RuGui.CreateWindow(1, 1, Configuration.Title)
        NewWindow:CreateContext()
        Context = NewWindow.Context

        for objIndex, ObjectData in pairs(RequiredModule) do
            local Packet = CreatePacket(Context, ObjectData)

            local Ref = Context["Create" .. ObjectData.Type](Context, table.unpack(Packet))
            Objects[ObjectData.Name] = Ref
        end

        NewWindow.WindowScreenGui.Parent = Parent
    else
        error("Required module is empty or invalid.")
    end
end

return RuGuiAdaptor