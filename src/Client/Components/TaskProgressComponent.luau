--!strict

local TaskProgressComponent = {}
TaskProgressComponent.__index = TaskProgressComponent

export type TaskProgressComponent = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
		_lastTaskId: string?,
		_taskCompletions: { [string]: number },
	},
	TaskProgressComponent
))

function TaskProgressComponent.new(feedbackService: any): TaskProgressComponent
	local self = setmetatable({
		_feedbackService = feedbackService,
		_lastTaskId = nil,
		_taskCompletions = {},
	}, TaskProgressComponent)

	return self
end

function TaskProgressComponent:Start()
	self._feedbackService.TaskCompletedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" or type(payload.taskId) ~= "string" then
			return
		end

		self._lastTaskId = payload.taskId
		self._taskCompletions[payload.taskId] = payload.timesCompleted or 0
	end)
end

function TaskProgressComponent:GetTaskCompletionCount(taskId: string): number
	return self._taskCompletions[taskId] or 0
end

function TaskProgressComponent:GetLastTaskId(): string?
	return self._lastTaskId
end

return TaskProgressComponent
