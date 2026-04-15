--!strict

local ObjectiveDefinition = require(script.Parent.ObjectiveDefinition)
type ObjectiveDefinition = ObjectiveDefinition.ObjectiveDefinition

local QuestDefinition = {}

export type QuestDefinition = {
	id: string,
	displayName: string,
	description: string,
	objectives: { ObjectiveDefinition },
}

local quests: { [string]: QuestDefinition } = {
	FirstShift = {
		id = "FirstShift",
		displayName = "First Shift",
		description = "Complete your first 3 car wash tasks.",
		objectives = {
			{
				id = "WashCars",
				taskId = "WashCar",
				requiredCount = 3,
			},
		},
	},
	CustomerRush = {
		id = "CustomerRush",
		displayName = "Customer Rush",
		description = "Serve 2 customers at the front desk.",
		objectives = {
			{
				id = "ServeCustomers",
				taskId = "ServeCustomer",
				requiredCount = 2,
			},
		},
	},
}

function QuestDefinition.isValid(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local data = value :: any
	if type(data.id) ~= "string" or data.id == "" then
		return false
	end

	if type(data.displayName) ~= "string" or type(data.description) ~= "string" then
		return false
	end

	if type(data.objectives) ~= "table" or #data.objectives == 0 then
		return false
	end

	for _, objective in ipairs(data.objectives) do
		if not ObjectiveDefinition.isValid(objective) then
			return false
		end
	end

	return true
end

function QuestDefinition.GetAll(): { [string]: QuestDefinition }
	return quests
end

function QuestDefinition.TryResolve(questId: string): QuestDefinition?
	return quests[questId]
end

for questId, quest in pairs(quests) do
	assert(QuestDefinition.isValid(quest), string.format("Invalid quest definition: %s", questId))
end

return QuestDefinition
