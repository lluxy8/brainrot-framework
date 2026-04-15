--!strict

local ZoneDefinition = {}

export type ZoneDefinition = {
	id: string,
	displayName: string,
	currency: string,
	unlockCost: number,
	prerequisiteZoneId: string?,
	unlockedByDefault: boolean,
}

function ZoneDefinition.isValid(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local data = value :: any
	return type(data.id) == "string"
		and data.id ~= ""
		and type(data.displayName) == "string"
		and type(data.currency) == "string"
		and type(data.unlockCost) == "number"
		and data.unlockCost >= 0
		and type(data.unlockedByDefault) == "boolean"
end

return ZoneDefinition
