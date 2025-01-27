local DataStoreService = game:GetService("DataStoreService")

local Interpreter = require(script.Interpreter)
local Packager = require(script.Packager)

local Roblox_Custom_Encryption = require(script.Parent.Parent.Utilities.RobloxCustomEncryption)

local ModDatastore = {}

-- << One key holds other Keys which are loaded to the game for the game to work!

function ModDatastore.GetMods(Filters:{name:string?, author:string?, page:number?})
    local Datastore = DataStoreService:GetDataStore("Mods")


end

return ModDatastore