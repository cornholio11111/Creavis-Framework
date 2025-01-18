local Players = game:GetService("Players")
local RuGui = require(script.Parent.RuGui)

local RuGuiAdaptor = {}
RuGuiAdaptor.__index = RuGuiAdaptor

RuGuiAdaptor.LoadedModules = {}

local function CreateOBJ(Context, ObjectData, ConnectFunctionality)
    local Packet = CreatePacket(Context, ObjectData)

    pcall(function()
        local ObjectContext = Context["Create" .. ObjectData.Type](Context, table.unpack(Packet))

        if ObjectData.Type == "Dropdown" then
            for index, OptionsData in pairs(ObjectData.Options) do
                CreateOBJ(Context, OptionsData, nil)
            end
        end

        if ConnectFunctionality then
            ConnectFunctionality(ObjectContext, ObjectData)
        end
    
    end, function(err)
        warn("Error creating object of type " .. ObjectData.Type .. ": " .. tostring(err))
    end)
end

function CreatePacket(Context, ObjectData)
    local Parent = nil

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

    print(ModuleReference, Parent, Configuration)

    if not Parent then
        error(".LoadModuleUI() failed to create UI, Parent wasn't sent.")
    end

    if not Configuration.Title then
        Configuration.Title = ModuleReference.Name
    end

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
            pcall(function()
                CreateOBJ(Context, ObjectData, ConnectFunctionality)
            end, function(err) warn(tostring(err)) end)
            task.wait()
        end

        for objIndex, ObjectData in pairs(Panels) do
            pcall(function()
                CreateOBJ(Context, ObjectData, ConnectFunctionality)
            end, function(err) warn(tostring(err)) end)
            task.wait()
        end

        for objIndex, ObjectData in pairs(Toolbar) do
            pcall(function()
                CreateOBJ(Context, ObjectData, ConnectFunctionality)
            end, function(err) warn(tostring(err)) end)
            task.wait()
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