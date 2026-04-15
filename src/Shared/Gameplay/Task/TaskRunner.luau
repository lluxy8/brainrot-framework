--!strict

local TaskDefinitionModule = require(script.Parent.TaskDefinition)
type TaskDefinition = TaskDefinitionModule.TaskDefinition

type Profile = {
	tasks: {
		completedCounts: { [string]: number },
	},
}

export type TaskRunResult = {
	taskId: string,
	progress: number,
	completed: boolean,
	timesCompleted: number,
}

local TaskRunner = {}

function TaskRunner.Complete(profile: Profile, taskDefinition: TaskDefinition): TaskRunResult
	local completedCounts = profile.tasks.completedCounts
	local previousCount = completedCounts[taskDefinition.id] or 0
	local nextCount = previousCount + 1
	completedCounts[taskDefinition.id] = nextCount

	return {
		taskId = taskDefinition.id,
		progress = taskDefinition.requiredProgress,
		completed = true,
		timesCompleted = nextCount,
	}
end

return TaskRunner
