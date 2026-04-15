--!strict

local UpgradeDefinition = {}

export type UpgradeDefinition = {
	id: string,
	displayName: string,
	currency: string,
	baseCost: number,
	costScale: number,
	maxLevel: number,
	taskRewardMultiplierPerLevel: number,
}

function UpgradeDefinition.isValid(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local data = value :: any
	return type(data.id) == "string"
		and data.id ~= ""
		and type(data.displayName) == "string"
		and type(data.currency) == "string"
		and type(data.baseCost) == "number"
		and data.baseCost >= 0
		and type(data.costScale) == "number"
		and data.costScale >= 1
		and type(data.maxLevel) == "number"
		and data.maxLevel >= 1
		and type(data.taskRewardMultiplierPerLevel) == "number"
		and data.taskRewardMultiplierPerLevel >= 0
end

return UpgradeDefinition
