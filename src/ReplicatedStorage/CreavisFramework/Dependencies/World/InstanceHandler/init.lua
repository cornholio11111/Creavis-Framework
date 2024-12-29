local InstanceHandler = {}
InstanceHandler.__index = InstanceHandler

function InstanceHandler.new(World)
    local self = setmetatable({}, InstanceHandler)
    self.WorldReference = World
    self.InstanceTemplates = {}

    self:LoadInstances()

    return self
end

function InstanceHandler:LoadInstances()
    for __index, OBJ in pairs(script.Instances) do
        if OBJ:IsA("ModuleScript") then
            local requireModule = require(OBJ)

            self.InstanceTemplates[OBJ.Name] = requireModule
            task.wait(.002) -- // 500 instances per second
        end
    end
end

return InstanceHandler