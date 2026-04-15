--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)
local StationResolver = require(Shared.Gameplay.Station.StationResolver)
local StationState = require(Shared.Constants.StationState)
local StationStateMachine = require(Shared.Gameplay.Station.StationStateMachine)

type StationRecord = {
	id: string,
	state: string,
	playerUserId: number?,
	lastUsedAt: number,
}

export type StationChangedPayload = {
	stationId: string,
	state: string,
	playerUserId: number?,
}

local StationService = {}
StationService.__index = StationService

export type StationService = typeof(setmetatable(
	{} :: {
		_zoneService: any,
		_stations: { [string]: StationRecord },
		StationChanged: Signal.Signal,
	},
	StationService
))

function StationService.new(zoneService: any): StationService
	local self = setmetatable({
		_zoneService = zoneService,
		_stations = {},
		StationChanged = Signal.new(),
	}, StationService)

	return self
end

function StationService:Start()
	for stationId in pairs(StationResolver.GetAll()) do
		self._stations[stationId] = {
			id = stationId,
			state = StationState.Idle,
			playerUserId = nil,
			lastUsedAt = 0,
		}
	end
end

function StationService:TryGetStation(stationId: string): StationRecord?
	return self._stations[stationId]
end

function StationService:_transition(
	station: StationRecord,
	nextState: string,
	playerUserId: number?
)
	if not StationStateMachine.CanTransition(station.state, nextState) then
		error(string.format("Invalid station transition %s -> %s", station.state, nextState))
	end

	station.state = nextState
	station.playerUserId = playerUserId
	self.StationChanged:Fire({
		stationId = station.id,
		state = station.state,
		playerUserId = station.playerUserId,
	} :: StationChangedPayload)
end

function StationService:ReserveStation(player: Player, stationId: string): (boolean, string?)
	local station = self:TryGetStation(stationId)
	if not station then
		return false, string.format("Station '%s' does not exist", stationId)
	end

	local definition = StationResolver.Resolve(stationId)
	if not self._zoneService:IsUnlocked(player, definition.zoneId) then
		return false, "Zone is locked for this player"
	end

	if station.state ~= StationState.Idle then
		return false, "Station is not idle"
	end

	self:_transition(station, StationState.Reserved, player.UserId)
	return true, nil
end

function StationService:BeginUse(player: Player, stationId: string): (boolean, string?)
	local station = self:TryGetStation(stationId)
	if not station then
		return false, string.format("Station '%s' does not exist", stationId)
	end

	if station.state == StationState.Idle then
		local reserved, reserveError = self:ReserveStation(player, stationId)
		if not reserved then
			return false, reserveError
		end
	end

	if station.playerUserId ~= player.UserId then
		return false, "Station is reserved by another player"
	end

	self:_transition(station, StationState.InUse, player.UserId)
	return true, nil
end

function StationService:ReleaseStation(stationId: string): (boolean, string?)
	local station = self:TryGetStation(stationId)
	if not station then
		return false, string.format("Station '%s' does not exist", stationId)
	end

	if station.state == StationState.Idle then
		return true, nil
	end

	self:_transition(station, StationState.Idle, nil)
	station.lastUsedAt = os.clock()
	return true, nil
end

return StationService
