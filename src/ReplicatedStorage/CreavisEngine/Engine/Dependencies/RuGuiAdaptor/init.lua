local Players = game:GetService("Players")
local RuGui = require(script.Parent.RuGui)

local RuGuiAdaptor = {}
RuGuiAdaptor.__index = RuGuiAdaptor

RuGuiAdaptor.LoadedModules = {}

-- CreateOBJ function optimized with direct function calls instead of using task.wait and coroutine.wrap
local function CreateOBJ(Context, ObjectData, ConnectFunctionality)
    local Packet = CreatePacket(Context, ObjectData)

    local Options = ObjectData.Options or {}
    local Type = ObjectData.Type

    local ObjectContext = Context["Create" .. Type](Context, table.unpack(Packet))

    -- Handle dropdown options if they exist
    if Type == "Dropdown" then
        for _, OptionsData in pairs(Options) do
            ObjectContext.AddOption(OptionsData, ObjectContext.DropdownBox)
        end
    end

    -- Connect functionality if it exists
    if ConnectFunctionality then
        ConnectFunctionality(ObjectContext, ObjectData)
    end
end

-- Optimized CreatePacket function
function CreatePacket(Context, ObjectData)
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

-- LoadModuleUI optimized by avoiding redundant task.wait
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

    local NewWindow
    local Context

    if RequiredModule then
        NewWindow = RuGui.CreateWindow(1, 1, Configuration.Title)
        NewWindow:CreateContext()
        Context = NewWindow.Context

        NewWindow.WindowScreenGui.Parent = Parent

        -- Optimized ConnectFunctionality function
        local function ConnectFunctionality(ObjectContext, ObjectData)
            local functionalityExist = RequiredModule.Functionality[ObjectData.Name]
            if functionalityExist then
                for _, _function in pairs(functionalityExist) do
                    _function(ObjectContext[ObjectData.Type])
                end
            end
        end

        local Toolbar = RequiredModule.Toolbar
        local Docks = RequiredModule.Docks
        local Panels = RequiredModule.Panels

        -- Process Docks, Panels, and Toolbar without task.wait or coroutine.wrap
        local function createObjects(ObjectDataTable)
            for _, ObjectData in pairs(ObjectDataTable) do
                pcall(function()
                    CreateOBJ(Context, ObjectData, ConnectFunctionality)
                end, function(err) warn(tostring(err)) end)
            end
        end

        createObjects(Docks)
        createObjects(Panels)
        createObjects(Toolbar)

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

-- Optimized FindModule function for fast lookup
function RuGuiAdaptor.FindModule(Title)
    return RuGuiAdaptor.LoadedModules[Title] or {}
end

return RuGuiAdaptor