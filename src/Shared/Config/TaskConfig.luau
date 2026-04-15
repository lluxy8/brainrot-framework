--!strict

local Currency = require(script.Parent.Parent.Constants.Currency)
local TaskDefinitionModule = require(script.Parent.Parent.Gameplay.Task.TaskDefinition)
type TaskDefinition = TaskDefinitionModule.TaskDefinition

local tasks: { [string]: TaskDefinition } = {
	WashCar = {
		id = "WashCar",
		displayName = "Wash Car",
		currency = Currency.Coins,
		baseReward = 25,
		requiredProgress = 1,
	},
	ServeCustomer = {
		id = "ServeCustomer",
		displayName = "Serve Customer",
		currency = Currency.Coins,
		baseReward = 40,
		requiredProgress = 1,
	},
}

for taskId, definition in pairs(tasks) do
	assert(
		TaskDefinitionModule.isValid(definition),
		string.format("Invalid task definition: %s", taskId)
	)
end

local TaskConfig = {
	Tasks = tasks,
	OrderedTaskIds = {
		"WashCar",
		"ServeCustomer",
	},
}

return table.freeze(TaskConfig)
