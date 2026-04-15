--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)
local TaskResolver = require(Shared.Gameplay.Task.TaskResolver)
local TaskRunner = require(Shared.Gameplay.Task.TaskRunner)

type TaskRunResult = TaskRunner.TaskRunResult

export type TaskCompletionResult = {
	taskId: string,
	displayName: string,
	runResult: TaskRunResult,
	reward: any,
}

local TaskService = {}
TaskService.__index = TaskService

export type TaskService = typeof(setmetatable(
	{} :: {
		_dataService: any,
		_rewardService: any,
		TaskCompleted: Signal.Signal,
	},
	TaskService
))

function TaskService.new(dataService: any, rewardService: any): TaskService
	local self = setmetatable({
		_dataService = dataService,
		_rewardService = rewardService,
		TaskCompleted = Signal.new(),
	}, TaskService)

	return self
end

function TaskService:Start()
	-- Intentionally empty. Triggered by gameplay actions.
end

function TaskService:CompleteTask(player: Player, taskId: string): (TaskCompletionResult?, string?)
	local taskDefinition = TaskResolver.TryResolve(taskId)
	if not taskDefinition then
		return nil, ("Task '%s' is not configured"):format(taskId)
	end

	local profile = self._dataService:GetOrCreateProfile(player)
	local runResult = TaskRunner.Complete(profile, taskDefinition)
	local rewardResult = self._rewardService:GrantTaskReward(player, taskDefinition, runResult)

	local completionResult: TaskCompletionResult = {
		taskId = taskDefinition.id,
		displayName = taskDefinition.displayName,
		runResult = runResult,
		reward = rewardResult,
	}

	self.TaskCompleted:Fire(player, completionResult)
	return completionResult, nil
end

function TaskService:GetTaskCompletionCount(player: Player, taskId: string): number
	return self._dataService:GetTaskCompletionCount(player, taskId)
end

return TaskService
