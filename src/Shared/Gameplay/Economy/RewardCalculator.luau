--!strict

local EconomyConfig = require(script.Parent.Parent.Parent.Config.EconomyConfig)
local TaskDefinitionModule = require(script.Parent.Parent.Task.TaskDefinition)
local TaskRunner = require(script.Parent.Parent.Task.TaskRunner)

type TaskDefinition = TaskDefinitionModule.TaskDefinition
type TaskRunResult = TaskRunner.TaskRunResult

local RewardCalculator = {}

local function getRepeatBonus(timesCompleted: number): number
	if timesCompleted <= 1 then
		return 0
	end

	return (timesCompleted - 1) * EconomyConfig.RepeatCompletionBonus
end

function RewardCalculator.CalculateTaskReward(
	taskDefinition: TaskDefinition,
	runResult: TaskRunResult
): number
	local baseReward = math.max(taskDefinition.baseReward, 0)
	local multipliedReward = baseReward * EconomyConfig.TaskRewardMultiplier
	local repeatBonus = getRepeatBonus(runResult.timesCompleted)

	local total = multipliedReward + repeatBonus
	return math.floor(math.max(total, 0))
end

return RewardCalculator
