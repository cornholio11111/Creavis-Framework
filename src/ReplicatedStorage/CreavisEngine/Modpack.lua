local Debris = game:GetService("Debris")

local ModpackExample = {
    VERSION = "v0.0.1";

    TITLE = "Modpack Example";
    SPECIAL_64BIT_ID = ""; -->> This is how we find the modpack data in the DataStoreService:GetDataStore()
      -- >> 64BIT ID | This is added once its uploaded to the DataStoreService
}
ModpackExample.__index = ModpackExample

function ModpackExample.Register() -- << This is called by my ModpackLoader, this handles your mod.

end

function ModpackExample:Cleanup() -- << This is called by my ModpackLoader, this is called when its removed or unloaded.

end

return ModpackExample