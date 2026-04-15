--!strict

local NotificationController = {}
NotificationController.__index = NotificationController

export type NotificationController = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
	},
	NotificationController
))

function NotificationController.new(feedbackService: any): NotificationController
	local self = setmetatable({
		_feedbackService = feedbackService,
	}, NotificationController)

	return self
end

function NotificationController:Start()
	self._feedbackService.InteractionResultReceived:Connect(function(payload: any)
		if type(payload) == "table" and payload.ok == false then
			warn(string.format("[Interaction] %s", tostring(payload.error)))
		end
	end)

	self._feedbackService.UpgradePurchaseResultReceived:Connect(function(payload: any)
		if type(payload) == "table" and payload.ok == false then
			warn(string.format("[Upgrade] %s", tostring(payload.error)))
		end
	end)

	self._feedbackService.ZoneUnlockResultReceived:Connect(function(payload: any)
		if type(payload) == "table" and payload.ok == false then
			warn(string.format("[Zone] %s", tostring(payload.error)))
		end
	end)

	self._feedbackService.QuestCompletedReceived:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.questId) == "string" then
			print(string.format("[Quest] Completed: %s", payload.questId))
		end
	end)
end

return NotificationController
