local Players = game:GetService("Players")
local RuGui = require(script.Parent.RuGui)

local RuGuiAdaptor = {}
RuGuiAdaptor.__index = RuGuiAdaptor

RuGuiAdaptor.LoadedModules = {}

local function CreatePacket(Context, ObjectData)
    local Parent = ObjectData.Dock or ObjectData.Parent
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

local function CreateOBJ(Context, ObjectData, ConnectFunctionality)
    local Packet = CreatePacket(Context, ObjectData)
    local ObjectType = ObjectData.Type

    local Options = ObjectData.Options or {}
    local Type = ObjectData.Type

    -- local ObjectContext = Context["Create" .. Type](Context, table.unpack(Packet))

    local ObjectContext = Context.CreateObject(Context, Type, table.unpack(Packet))

    if ObjectType == "Dropdown" then
       local SortedOptions = {}

        for _, OptionsData in pairs(Options) do
            table.insert(SortedOptions, OptionsData)
        end

        table.sort(SortedOptions, function(a, b)
            return (a.Priority or 0) < (b.Priority or 0)
        end)

        for _, OptionsData in ipairs(SortedOptions) do
            ObjectContext.AddOption(OptionsData, ObjectContext.DropdownBox)
        end
    end

    -- Connect functionality if it exists
    if ConnectFunctionality then
        ConnectFunctionality(ObjectContext, ObjectData)
    end
end

function RuGuiAdaptor.LoadModuleUI(ModuleReference: ModuleScript | string, Parent: any, Configuration: {Title: string?})
    if typeof(ModuleReference) == "string" then
        ModuleReference = script:FindFirstChild(ModuleReference) or error("Module not found")
    end

    if not Parent then
        error(".LoadModuleUI() failed to create UI, Parent wasn't sent.")
    end

    if not Configuration.Title then
        Configuration.Title = ModuleReference.Name .. " (Module UI)"
    end

    local RequiredModule = require(ModuleReference)

    if not RequiredModule then
        error("Required module is empty or invalid.")
    end

    local NewWindow = RuGui.CreateWindow(1, 1, Configuration.Title)
    NewWindow:CreateContext()
    local Context = NewWindow.Context
    NewWindow.WindowScreenGui.Parent = Parent

    local function ConnectFunctionality(Object, ObjectData)
        local functionalityExist = RequiredModule.Functionality[ObjectData.Name]

        if functionalityExist then
            for _, _function in pairs(functionalityExist) do
                _function(Object[ObjectData.Type])
            end
        end
    end

    local function CreateObjects(ObjectDataTable)
        for _, ObjectData in pairs(ObjectDataTable) do
            local success, err = pcall(function()
                CreateOBJ(Context, ObjectData, ConnectFunctionality)
            end)

            if not success then
                warn(string.format("Error creating object '%s': %s", ObjectData.Name or "Unknown", err))
            end
        end
    end    

    CreateObjects(RequiredModule.Docks)
    CreateObjects(RequiredModule.Panels)
    CreateObjects(RequiredModule.Toolbar)
    CreateObjects(RequiredModule.QuickActions)

    local Data = {
        Window = NewWindow,
        Context = Context,
        Module = RequiredModule,
    }

    RuGuiAdaptor.LoadedModules[Configuration.Title] = Data

    return Data
end

function RuGuiAdaptor.FindModule(Title)
    return RuGuiAdaptor.LoadedModules[Title] or {}
end

return RuGuiAdaptor