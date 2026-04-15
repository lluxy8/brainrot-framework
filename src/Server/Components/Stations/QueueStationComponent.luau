--!strict

local QueueStationComponent = {}
QueueStationComponent.__index = QueueStationComponent

export type QueueStationComponent = typeof(setmetatable(
	{} :: {
		_stationService: any,
	},
	QueueStationComponent
))

function QueueStationComponent.new(stationService: any): QueueStationComponent
	local self = setmetatable({
		_stationService = stationService,
	}, QueueStationComponent)

	return self
end

function QueueStationComponent:Start()
	-- Intentionally empty.
end

function QueueStationComponent:JoinQueue(player: Player, stationId: string): (boolean, string?)
	return self._stationService:ReserveStation(player, stationId)
end

function QueueStationComponent:LeaveQueue(stationId: string): (boolean, string?)
	return self._stationService:ReleaseStation(stationId)
end

return QueueStationComponent
