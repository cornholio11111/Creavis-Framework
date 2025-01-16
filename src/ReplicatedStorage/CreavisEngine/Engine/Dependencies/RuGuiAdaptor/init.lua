local Players = game:GetService("Players")
local RuGui = require(script.Parent.RuGui)

local RuGuiAdaptor = {}
RuGuiAdaptor.__index = RuGuiAdaptor

RuGuiAdaptor.LoadedModules = {}

function DetectType(Context, ObjectData) -- << Extra Code for depending object types
    local returnedData = {}

    if ObjectData.Type == "Widget" then
        
    end

    if ObjectData.Type == "Dock" then
        
    end

    if ObjectData.Type == "Button" then
        
    end

    if ObjectData.Type == "Menu" then
        
    end

    return returnedData
end

function CreatePacket(Context, ObjectData)
    local Parent = nil

    -- local returnedTypeData = DetectType(Context, ObjectData)
    -- << Prob will add back in for more in-depth customizations ig

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

    -- if ObjectData.Folder then
    --     local WindowScreenGui = Context.RuGuiData.WindowScreenGui
    --     local Par = WindowScreenGui:FindFirstChild(ObjectData.Folder)

    --     if Par then
    --         Parent = Par
    --     else
    --         print("Warning: Folder not found for " .. ObjectData.Folder)
    --     end
    -- end

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

        NewWindow.WindowScreenGui.Parent = Parent

        local function ConnectFunctionality(ObjectContext, ObjectData)
            local functionalityExist = RequiredModule.Functionality[ObjectData.Name]

            if functionalityExist then
                for index, _function in pairs(functionalityExist) do
                    _function(ObjectContext[ObjectData.Type])
                end
            end
        end

        local Toolbar = RequiredModule.Toolbar
        local Docks = RequiredModule.Docks
        local Panels = RequiredModule.Panels

        for objIndex, ObjectData in pairs(Docks) do
            local Packet = CreatePacket(Context, ObjectData)

            pcall(function()
                local ObjectContext = Context["Create" .. ObjectData.Type](Context, table.unpack(Packet))
                ConnectFunctionality(ObjectContext, ObjectData)
            end, function(err)
                warn("Error creating object of type " .. ObjectData.Type .. ": " .. tostring(err))
            end)
        end

        for objIndex, ObjectData in pairs(Toolbar) do
            local Packet = CreatePacket(Context, ObjectData)

            pcall(function()
                local ObjectContext = Context["Create" .. ObjectData.Type](Context, table.unpack(Packet))
                ConnectFunctionality(ObjectContext, ObjectData)
            end, function(err)
                warn("Error creating object of type " .. ObjectData.Type .. ": " .. tostring(err))
            end)
        end

        for objIndex, ObjectData in pairs(Panels) do
            local Packet = CreatePacket(Context, ObjectData)

            pcall(function()
                local ObjectContext = Context["Create" .. ObjectData.Type](Context, table.unpack(Packet))
                ConnectFunctionality(ObjectContext, ObjectData)
            end, function(err)
                warn("Error creating object of type " .. ObjectData.Type .. ": " .. tostring(err))
            end)
        end

        --NewWindow.WindowScreenGui.Parent = Parent
    else
        error("Required module is empty or invalid.")
    end

    local Data = {
        Window = NewWindow;
        Context = Context;

        Module = RequiredModule
    }

    RuGuiAdaptor.LoadedModules[Configuration.Title] = Data

    return Data
end

function RuGuiAdaptor.FindModule(Title)
    return RuGuiAdaptor.LoadedModules[Title] or {}
end

return RuGuiAdaptor