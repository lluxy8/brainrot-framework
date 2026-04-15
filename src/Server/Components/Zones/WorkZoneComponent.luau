--!strict

local WorkZoneComponent = {}
WorkZoneComponent.__index = WorkZoneComponent

export type WorkZoneComponent = typeof(setmetatable(
	{} :: {
		_zoneService: any,
	},
	WorkZoneComponent
))

function WorkZoneComponent.new(zoneService: any): WorkZoneComponent
	local self = setmetatable({
		_zoneService = zoneService,
	}, WorkZoneComponent)

	return self
end

function WorkZoneComponent:Start()
	-- Intentionally empty.
end

function WorkZoneComponent:IsPlayerAllowed(player: Player, zoneId: string): boolean
	return self._zoneService:IsUnlocked(player, zoneId)
end

return WorkZoneComponent
