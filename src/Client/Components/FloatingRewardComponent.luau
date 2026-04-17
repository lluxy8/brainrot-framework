--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Currency = require(Shared.Constants.Currency)
local AssetConfig = require(Shared.Config.AssetConfig)

local FloatingRewardComponent = {}
FloatingRewardComponent.__index = FloatingRewardComponent

export type FloatingRewardComponent = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
		_audioService: any,
		_player: Player,
	},
	FloatingRewardComponent
))

function FloatingRewardComponent.new(
	feedbackService: any,
	audioService: any
): FloatingRewardComponent
	local self = setmetatable({
		_feedbackService = feedbackService,
		_audioService = audioService,
		_player = Players.LocalPlayer,
	}, FloatingRewardComponent)

	return self
end

function FloatingRewardComponent:Start()
	self._feedbackService.TaskCompletedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" then
			return
		end

		self._player:SetAttribute("Brainrot_FloatingReward_Amount", payload.rewardAmount or 0)
		self._player:SetAttribute("Brainrot_FloatingReward_TaskId", payload.taskId or "")

		if payload.rewardAmount and payload.rewardAmount > 0 then
			self._audioService:Play2D(AssetConfig.Sounds.TaskReward, 0.35, 1.1)
		end
	end)

	self._feedbackService.EconomyUpdatedReceived:Connect(function(payload: any)
		if type(payload) == "table" and payload.currency == Currency.Coins then
			self._player:SetAttribute("Brainrot_FloatingReward_Balance", payload.balance or 0)
		end
	end)
end

return FloatingRewardComponent
