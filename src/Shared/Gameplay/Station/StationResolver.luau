--!strict

local StationDefinition = require(script.Parent.StationDefinition)
type StationDefinitionType = StationDefinition.StationDefinition

local StationResolver = {}

function StationResolver.TryResolve(stationId: string): StationDefinitionType?
	return StationDefinition.GetAll()[stationId]
end

function StationResolver.Resolve(stationId: string): StationDefinitionType
	local definition = StationResolver.TryResolve(stationId)
	if not definition then
		error(string.format("Station '%s' is not defined", stationId))
	end

	return definition
end

function StationResolver.GetAll(): { [string]: StationDefinitionType }
	return StationDefinition.GetAll()
end

return StationResolver
