--!strict

local InteractionTypes = require(script.Parent.InteractionTypes)

local InteractionDefinition = {}

export type InteractionDefinition = {
	id: string,
	displayName: string,
	interactionType: string,
	taskId: string?,
	stationId: string?,
	cooldownSeconds: number,
}

local definitions: { [string]: InteractionDefinition } = {
	WashCarInteract = {
		id = "WashCarInteract",
		displayName = "Wash Car",
		interactionType = InteractionTypes.Click,
		taskId = "WashCar",
		stationId = "CarWashStation",
		cooldownSeconds = 0.5,
	},
	ServeCustomerInteract = {
		id = "ServeCustomerInteract",
		displayName = "Serve Customer",
		interactionType = InteractionTypes.Proximity,
		taskId = "ServeCustomer",
		stationId = "FrontDeskStation",
		cooldownSeconds = 0.5,
	},
}

function InteractionDefinition.TryResolve(interactionId: string): InteractionDefinition?
	return definitions[interactionId]
end

function InteractionDefinition.Resolve(interactionId: string): InteractionDefinition
	local definition = InteractionDefinition.TryResolve(interactionId)
	if not definition then
		error(string.format("Interaction '%s' is not defined", interactionId))
	end

	return definition
end

function InteractionDefinition.GetAll(): { [string]: InteractionDefinition }
	return definitions
end

return InteractionDefinition
