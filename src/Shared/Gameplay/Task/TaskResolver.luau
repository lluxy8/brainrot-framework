--!strict

local TaskConfig = require(script.Parent.Parent.Parent.Config.TaskConfig)
local TaskDefinitionModule = require(script.Parent.TaskDefinition)
type TaskDefinition = TaskDefinitionModule.TaskDefinition

local TaskResolver = {}

function TaskResolver.TryResolve(taskId: string): TaskDefinition?
	return TaskConfig.Tasks[taskId]
end

function TaskResolver.Resolve(taskId: string): TaskDefinition
	local definition = TaskResolver.TryResolve(taskId)
	if not definition then
		error(string.format("Task '%s' is not defined in TaskConfig", taskId))
	end

	return definition
end

function TaskResolver.GetAll(): { [string]: TaskDefinition }
	return TaskConfig.Tasks
end

return TaskResolver
