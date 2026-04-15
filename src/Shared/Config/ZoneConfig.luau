--!strict

local Currency = require(script.Parent.Parent.Constants.Currency)
local ZoneDefinitionModule = require(script.Parent.Parent.Gameplay.Zone.ZoneDefinition)
type ZoneDefinition = ZoneDefinitionModule.ZoneDefinition

local zones: { [string]: ZoneDefinition } = {
	StarterZone = {
		id = "StarterZone",
		displayName = "Starter Zone",
		currency = Currency.Coins,
		unlockCost = 0,
		prerequisiteZoneId = nil,
		unlockedByDefault = true,
	},
	MarketZone = {
		id = "MarketZone",
		displayName = "Market Zone",
		currency = Currency.Coins,
		unlockCost = 300,
		prerequisiteZoneId = "StarterZone",
		unlockedByDefault = false,
	},
}

for zoneId, definition in pairs(zones) do
	assert(
		ZoneDefinitionModule.isValid(definition),
		string.format("Invalid zone definition: %s", zoneId)
	)
end

local ZoneConfig = {
	Zones = zones,
}

return table.freeze(ZoneConfig)
