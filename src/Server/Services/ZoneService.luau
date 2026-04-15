--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)
local ZoneConfig = require(Shared.Config.ZoneConfig)
local ZoneDefinitionModule = require(Shared.Gameplay.Zone.ZoneDefinition)
type ZoneDefinition = ZoneDefinitionModule.ZoneDefinition

export type ZoneUnlockedPayload = {
	zoneId: string,
	cost: number,
	currency: string,
}

local ZoneService = {}
ZoneService.__index = ZoneService

export type ZoneService = typeof(setmetatable(
	{} :: {
		_dataService: any,
		_economyService: any,
		_zones: { [string]: ZoneDefinition },
		ZoneUnlocked: Signal.Signal,
	},
	ZoneService
))

function ZoneService.new(dataService: any, economyService: any): ZoneService
	local self = setmetatable({
		_dataService = dataService,
		_economyService = economyService,
		_zones = ZoneConfig.Zones,
		ZoneUnlocked = Signal.new(),
	}, ZoneService)

	return self
end

function ZoneService:Start()
	-- Zone defaults are applied lazily in IsUnlocked/GetUnlockedZones.
end

function ZoneService:TryResolve(zoneId: string): ZoneDefinition?
	return self._zones[zoneId]
end

function ZoneService:_ensureDefaults(player: Player)
	for zoneId, definition in pairs(self._zones) do
		if
			definition.unlockedByDefault and not self._dataService:IsZoneUnlocked(player, zoneId)
		then
			self._dataService:SetZoneUnlocked(player, zoneId, true)
		end
	end
end

function ZoneService:IsUnlocked(player: Player, zoneId: string): boolean
	self:_ensureDefaults(player)
	return self._dataService:IsZoneUnlocked(player, zoneId)
end

function ZoneService:GetUnlockedZones(player: Player): { [string]: boolean }
	self:_ensureDefaults(player)
	return self._dataService:GetUnlockedZones(player)
end

function ZoneService:UnlockZone(
	player: Player,
	zoneId: string
): (boolean, string?, ZoneUnlockedPayload?)
	local definition = self:TryResolve(zoneId)
	if not definition then
		return false, string.format("Zone '%s' is not defined", zoneId), nil
	end

	self:_ensureDefaults(player)

	if self._dataService:IsZoneUnlocked(player, zoneId) then
		return false, "Zone is already unlocked", nil
	end

	local prerequisiteZoneId = definition.prerequisiteZoneId
	if prerequisiteZoneId and not self._dataService:IsZoneUnlocked(player, prerequisiteZoneId) then
		return false, string.format("Prerequisite zone '%s' is locked", prerequisiteZoneId), nil
	end

	if definition.unlockCost > 0 then
		local spent =
			self._economyService:SpendCurrency(player, definition.currency, definition.unlockCost)
		if not spent then
			return false, "Not enough currency", nil
		end
	end

	self._dataService:SetZoneUnlocked(player, zoneId, true)

	local payload: ZoneUnlockedPayload = {
		zoneId = zoneId,
		cost = definition.unlockCost,
		currency = definition.currency,
	}

	self.ZoneUnlocked:Fire(player, payload)
	return true, nil, payload
end

return ZoneService
