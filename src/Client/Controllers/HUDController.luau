--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Currency = require(Shared.Constants.Currency)

local HUDController = {}
HUDController.__index = HUDController

export type HUDController = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
		_player: Player,
	},
	HUDController
))

function HUDController.new(feedbackService: any): HUDController
	local self = setmetatable({
		_feedbackService = feedbackService,
		_player = Players.LocalPlayer,
	}, HUDController)

	return self
end

function HUDController:Start()
	self._feedbackService.EconomyUpdatedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" or type(payload.currency) ~= "string" then
			return
		end

		if payload.currency == Currency.Coins then
			self._player:SetAttribute("Brainrot_Coins", payload.balance or 0)
		end
	end)

	self._feedbackService.TaskCompletedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" then
			return
		end

		self._player:SetAttribute("Brainrot_LastTaskId", payload.taskId or "")
		self._player:SetAttribute("Brainrot_LastRewardAmount", payload.rewardAmount or 0)
	end)

	self._feedbackService.SnapshotReceived:Connect(function(payload: any)
		if type(payload) ~= "table" then
			return
		end

		local currencies = payload.currencies
		if type(currencies) == "table" then
			self._player:SetAttribute("Brainrot_Coins", currencies[Currency.Coins] or 0)
		end

		local unlockedZones = payload.unlockedZones
		if type(unlockedZones) == "table" then
			local unlockedCount = 0
			for _, unlocked in pairs(unlockedZones) do
				if unlocked then
					unlockedCount += 1
				end
			end
			self._player:SetAttribute("Brainrot_UnlockedZoneCount", unlockedCount)
		end
	end)
end

return HUDController
