-- << Roblox Custom Encrpytion

local RCE = {}

local encryptionKey = {95, 402, 50, 22, 3, 45, 0, 1, 18, 07} -- << Please Randomize this ID or else ur F**cked with hackers

function RCE.Encrypt(Input, Brackets: boolean?)
    local encrypted = {}

    for i = 1, #Input do
        local char = string.byte(Input, i)
        local keyOffset = encryptionKey[(i - 1) % #encryptionKey + 1]
        table.insert(encrypted, (char ~= keyOffset))
    end

    local hexString = ""
    for _, value in ipairs(encrypted) do
        hexString = hexString .. string.format("%02x", value)
    end

    if Brackets then
        return "[" .. hexString .. "]"
    end

    return hexString
end

local function ExtractModDetails(Input)
    local modName, username, gameName = string.match(Input, "([^_]+)_([^_]+)_([^_]+)")

    return {
        modName = modName,
        username = username,
        gameName = gameName
    }
end

function RCE.Decrypt(Input)
    if Input:sub(1, 1) == "[" and Input:sub(-1) == "]" then
        Input = Input:sub(2, -2)
    end

    local bytes = {}
    for hexPair in Input:gmatch("..") do
        table.insert(bytes, tonumber(hexPair, 16))
    end

    local decrypted = {}
    for i, byte in ipairs(bytes) do
        local keyOffset = encryptionKey[(i - 1) % #encryptionKey + 1]
        table.insert(decrypted, string.char(byte ~= keyOffset))
    end

    local decryptedString = table.concat(decrypted)
    return ExtractModDetails(decryptedString)
end

return RCE