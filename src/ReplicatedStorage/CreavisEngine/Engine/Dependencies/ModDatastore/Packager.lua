--[[
Packager, used to package data & compress it for final upload process.
Only grabs changed properties of objects, things like scripts it saves the scipt itself & location 
'game.ReplicatedStorage.ExampleFolder.ExampleScriptLocation' & classname.

]]--

local Packager = {}
Packager.__index = Packager

function Packager.new()
    local self = setmetatable(Packager, {})

    self.CompressedPackage = {} -- << This is the final product that gets saved to the datastore keep it clean... please self
    self.Data = {} -- << This gets packed with alot of data, nothing optimized idk just data

    self.Configurations = {
        MAX_KEY_SIZE_KB = 4000;
    }

    return self
end

function Packager:CreatePackage()
    
end

function Packager:Unpackage()
    
end

return Packager