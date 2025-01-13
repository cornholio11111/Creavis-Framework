local EnumList = require(script.Parent.Parent.Parent.Utilities.EnumList)

local ControllerState = EnumList.new("ControllerState", {
    "Idle";
    "Moving";
    "Frozen";
})

local Controller = {}

Controller.CanFly = true

Controller.Position = Vector3.new(0, 0, 0)
Controller.Rotation = Vector3.new(0, 0, 0)

Controller.State = ControllerState.Idle

return Controller
