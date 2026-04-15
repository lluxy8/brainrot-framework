--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local RewardCalculator = require(Shared.Gameplay.Economy.RewardCalculator)
local TaskDefinitionModule = require(Shared.Gameplay.Task.TaskDefinition)
local TaskRunner = require(Shared.Gameplay.Task.TaskRunner)

type TaskDefinition = TaskDefinitionModule.TaskDefinition
type TaskRunResult = TaskRunner.TaskRunResult

export type RewardGrantResult = {
	taskId: string,
	currency: string,
	amount: number,
	newBalance: number,
}

local RewardService = {}
RewardService.__index = RewardService

export type RewardService = typeof(setmetatable(
	{} :: {
		_economyService: any,
		_upgradeService: any?,
	},
	RewardService
))

function RewardService.new(economyService: any): RewardService
	local self = setmetatable({
		_economyService = economyService,
		_upgradeService = nil,
	}, RewardService)

	return self
end

function RewardService:Start()
	-- Intentionally empty. RewardService is stateless.
end

function RewardService:SetUpgradeService(upgradeService: any)
	self._upgradeService = upgradeService
end

function RewardService:GrantTaskReward(
	player: Player,
	taskDefinition: TaskDefinition,
	runResult: TaskRunResult
): RewardGrantResult
	local rewardAmount = RewardCalculator.CalculateTaskReward(taskDefinition, runResult)
	if self._upgradeService then
		local multiplier = self._upgradeService:GetTaskRewardMultiplier(player)
		rewardAmount = math.floor(rewardAmount * multiplier)
	end

	local nextBalance = self._economyService:GetBalance(player, taskDefinition.currency)
	if rewardAmount > 0 then
		nextBalance = self._economyService:AddCurrency(
			player,
			taskDefinition.currency,
			rewardAmount,
			("TaskReward:%s"):format(taskDefinition.id)
		)
	end

	return {
		taskId = taskDefinition.id,
		currency = taskDefinition.currency,
		amount = rewardAmount,
		newBalance = nextBalance,
	}
end

return RewardService
