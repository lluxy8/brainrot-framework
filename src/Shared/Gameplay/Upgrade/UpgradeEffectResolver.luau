--!strict

local UpgradeDefinitionModule = require(script.Parent.UpgradeDefinition)
type UpgradeDefinition = UpgradeDefinitionModule.UpgradeDefinition

local UpgradeEffectResolver = {}

function UpgradeEffectResolver.GetUpgradeCost(
	definition: UpgradeDefinition,
	currentLevel: number
): number
	local normalizedLevel = math.max(0, math.floor(currentLevel))
	local scaledCost = definition.baseCost * (definition.costScale ^ normalizedLevel)
	return math.max(0, math.floor(scaledCost))
end

function UpgradeEffectResolver.GetTaskRewardMultiplier(
	upgradeLevels: { [string]: number },
	upgradeDefinitions: { [string]: UpgradeDefinition }
): number
	local bonus = 0

	for upgradeId, level in pairs(upgradeLevels) do
		local definition = upgradeDefinitions[upgradeId]
		if definition then
			local cappedLevel = math.clamp(math.floor(level), 0, definition.maxLevel)
			bonus += cappedLevel * definition.taskRewardMultiplierPerLevel
		end
	end

	return 1 + bonus
end

return UpgradeEffectResolver
