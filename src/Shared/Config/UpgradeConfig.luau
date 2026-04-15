--!strict

local Currency = require(script.Parent.Parent.Constants.Currency)
local UpgradeDefinitionModule = require(script.Parent.Parent.Gameplay.Upgrade.UpgradeDefinition)
type UpgradeDefinition = UpgradeDefinitionModule.UpgradeDefinition

local upgrades: { [string]: UpgradeDefinition } = {
	SpeedGloves = {
		id = "SpeedGloves",
		displayName = "Speed Gloves",
		currency = Currency.Coins,
		baseCost = 100,
		costScale = 1.5,
		maxLevel = 5,
		taskRewardMultiplierPerLevel = 0.05,
	},
	TipJar = {
		id = "TipJar",
		displayName = "Tip Jar",
		currency = Currency.Coins,
		baseCost = 200,
		costScale = 1.75,
		maxLevel = 4,
		taskRewardMultiplierPerLevel = 0.08,
	},
}

for upgradeId, definition in pairs(upgrades) do
	assert(
		UpgradeDefinitionModule.isValid(definition),
		string.format("Invalid upgrade definition: %s", upgradeId)
	)
end

local UpgradeConfig = {
	Upgrades = upgrades,
}

return table.freeze(UpgradeConfig)
