--!strict

local PromptController = {}
PromptController.__index = PromptController

export type PromptController = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
		_inputService: any,
		_activeInteractionId: string?,
		_lastRequestId: string?,
	},
	PromptController
))

function PromptController.new(feedbackService: any, inputService: any): PromptController
	local self = setmetatable({
		_feedbackService = feedbackService,
		_inputService = inputService,
		_activeInteractionId = nil,
		_lastRequestId = nil,
	}, PromptController)

	return self
end

function PromptController:Start()
	self._inputService.InteractionPressed:Connect(function()
		local interactionId = self._activeInteractionId
		if interactionId then
			self:TriggerInteraction(interactionId)
		end
	end)
end

function PromptController:TriggerInteraction(interactionId: string): string
	local requestId = self._feedbackService:RequestInteraction(interactionId)
	self._lastRequestId = requestId
	return requestId
end

function PromptController:SetActiveInteraction(interactionId: string?)
	self._activeInteractionId = interactionId
end

function PromptController:GetActiveInteraction(): string?
	return self._activeInteractionId
end

return PromptController
