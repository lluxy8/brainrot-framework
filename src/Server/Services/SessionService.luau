--!strict

local SessionService = {}
SessionService.__index = SessionService

export type SessionTaskResult = {
	taskId: string,
	rewardAmount: number,
	balance: number,
	timesCompleted: number,
}

export type SessionService = typeof(setmetatable(
	{} :: {
		_taskService: any,
	},
	SessionService
))

function SessionService.new(taskService: any): SessionService
	local self = setmetatable({
		_taskService = taskService,
	}, SessionService)

	return self
end

function SessionService:Start()
	-- Intentionally empty. Call CompleteTaskForPlayer from gameplay interactions.
end

function SessionService:CompleteTaskForPlayer(
	player: Player,
	taskId: string
): (SessionTaskResult?, string?)
	local completionResult, err = self._taskService:CompleteTask(player, taskId)
	if not completionResult then
		return nil, err
	end

	local reward = completionResult.reward
	return {
		taskId = completionResult.taskId,
		rewardAmount = reward.amount,
		balance = reward.newBalance,
		timesCompleted = completionResult.runResult.timesCompleted,
	},
		nil
end

return SessionService
