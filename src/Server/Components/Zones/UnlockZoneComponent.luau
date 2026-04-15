--!strict

local UnlockZoneComponent = {}
UnlockZoneComponent.__index = UnlockZoneComponent

export type UnlockZoneComponent = typeof(setmetatable(
	{} :: {
		_zoneService: any,
	},
	UnlockZoneComponent
))

function UnlockZoneComponent.new(zoneService: any): UnlockZoneComponent
	local self = setmetatable({
		_zoneService = zoneService,
	}, UnlockZoneComponent)

	return self
end

function UnlockZoneComponent:Start()
	-- Intentionally empty.
end

function UnlockZoneComponent:Unlock(player: Player, zoneId: string): (boolean, string?, any?)
	return self._zoneService:UnlockZone(player, zoneId)
end

return UnlockZoneComponent
