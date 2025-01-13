type EnumNames = { string }

export type EnumItem = {
	Name: string,
	Value: number,
	EnumType: any,
}

local LIST_KEY = newproxy()
local NAME_KEY = newproxy()

local function CreateEnumItem(name: string, value: number, enum: any): EnumItem
	local enumItem = {
		Name = name,
		Value = value,
		EnumType = enum,
	}
	table.freeze(enumItem)
	return enumItem
end

local EnumList = {}
EnumList.__index = EnumList
EnumList.Enums = {}

function EnumList.new(name: string, enums: EnumNames)
	assert(type(name) == "string", "Name string required")
	assert(type(enums) == "table", "Enums table required")
	local self = setmetatable({}, EnumList)
	self[LIST_KEY] = {}
	self[NAME_KEY] = name
	for i, enumName in ipairs(enums) do
		assert(type(enumName) == "string", "Enum name must be a string")
		local enumItem = CreateEnumItem(enumName, i, self)
		self[enumName] = enumItem
		table.insert(self[LIST_KEY], enumItem)
	end
	EnumList.Enums[name] = self
	return table.freeze(self)
end

function EnumList:BelongsTo(obj: any): boolean
	return type(obj) == "table" and obj.EnumType == self
end

function EnumList:GetEnumItems()
	return self[LIST_KEY]
end

function EnumList:GetName()
	return self[NAME_KEY]
end

export type EnumList = typeof(EnumList.new(...))

return EnumList