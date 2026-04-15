--!strict

local Players = game:GetService("Players")

local ProgressBarController = {}
ProgressBarController.__index = ProgressBarController

export type ProgressBarController = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
		_player: Player,
	},
	ProgressBarController
))

function ProgressBarController.new(feedbackService: any): ProgressBarController
	local self = setmetatable({
		_feedbackService = feedbackService,
		_player = Players.LocalPlayer,
	}, ProgressBarController)

	return self
end

function ProgressBarController:Start()
	self._feedbackService.TaskCompletedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" then
			return
		end

		self._player:SetAttribute("Brainrot_TaskProgress_TaskId", payload.taskId or "")
		self._player:SetAttribute(
			"Brainrot_TaskProgress_TimesCompleted",
			payload.timesCompleted or 0
		)
	end)

	self._feedbackService.QuestProgressedReceived:Connect(function(payload: any)
		if type(payload) ~= "table" then
			return
		end

		self._player:SetAttribute("Brainrot_QuestProgress_QuestId", payload.questId or "")
		self._player:SetAttribute("Brainrot_QuestProgress_ObjectiveId", payload.objectiveId or "")
		self._player:SetAttribute("Brainrot_QuestProgress_Value", payload.progress or 0)
		self._player:SetAttribute("Brainrot_QuestProgress_Required", payload.requiredCount or 0)
	end)
end

return ProgressBarController
