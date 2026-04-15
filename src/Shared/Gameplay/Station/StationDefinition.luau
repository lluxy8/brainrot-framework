--!strict

local StationDefinition = {}

export type StationDefinition = {
	id: string,
	displayName: string,
	zoneId: string,
	taskId: string,
	cooldownSeconds: number,
}

local definitions: { [string]: StationDefinition } = {
	CarWashStation = {
		id = "CarWashStation",
		displayName = "Car Wash Station",
		zoneId = "StarterZone",
		taskId = "WashCar",
		cooldownSeconds = 0.5,
	},
	FrontDeskStation = {
		id = "FrontDeskStation",
		displayName = "Front Desk",
		zoneId = "StarterZone",
		taskId = "ServeCustomer",
		cooldownSeconds = 0.5,
	},
}

function StationDefinition.isValid(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local data = value :: any
	return type(data.id) == "string"
		and data.id ~= ""
		and type(data.displayName) == "string"
		and type(data.zoneId) == "string"
		and type(data.taskId) == "string"
		and type(data.cooldownSeconds) == "number"
		and data.cooldownSeconds >= 0
end

function StationDefinition.GetAll(): { [string]: StationDefinition }
	return definitions
end

return StationDefinition
