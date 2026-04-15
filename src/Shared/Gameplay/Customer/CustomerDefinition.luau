--!strict

local CustomerDefinition = {}

export type CustomerDefinition = {
	id: string,
	displayName: string,
	basePatienceSeconds: number,
	rewardMultiplier: number,
}

local definitions: { [string]: CustomerDefinition } = {
	Regular = {
		id = "Regular",
		displayName = "Regular Customer",
		basePatienceSeconds = 45,
		rewardMultiplier = 1,
	},
	VIP = {
		id = "VIP",
		displayName = "VIP Customer",
		basePatienceSeconds = 30,
		rewardMultiplier = 1.5,
	},
}

function CustomerDefinition.TryResolve(customerTypeId: string): CustomerDefinition?
	return definitions[customerTypeId]
end

function CustomerDefinition.Resolve(customerTypeId: string): CustomerDefinition
	local definition = CustomerDefinition.TryResolve(customerTypeId)
	if not definition then
		error(string.format("Customer type '%s' is not defined", customerTypeId))
	end

	return definition
end

function CustomerDefinition.GetAll(): { [string]: CustomerDefinition }
	return definitions
end

return CustomerDefinition
