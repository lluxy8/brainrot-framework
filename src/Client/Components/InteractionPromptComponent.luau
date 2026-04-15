--!strict

local InteractionPromptComponent = {}
InteractionPromptComponent.__index = InteractionPromptComponent

export type InteractionPromptComponent = typeof(setmetatable(
	{} :: {
		_promptController: any,
		_boundPrompts: { ProximityPrompt },
	},
	InteractionPromptComponent
))

function InteractionPromptComponent.new(promptController: any): InteractionPromptComponent
	local self = setmetatable({
		_promptController = promptController,
		_boundPrompts = {},
	}, InteractionPromptComponent)

	return self
end

function InteractionPromptComponent:Start()
	-- Intentionally empty. Bind prompts with BindPrompt.
end

function InteractionPromptComponent:BindPrompt(prompt: ProximityPrompt, interactionId: string)
	table.insert(self._boundPrompts, prompt)
	prompt.Triggered:Connect(function()
		self._promptController:TriggerInteraction(interactionId)
	end)
	prompt.PromptShown:Connect(function()
		self._promptController:SetActiveInteraction(interactionId)
	end)
	prompt.PromptHidden:Connect(function()
		if self._promptController:GetActiveInteraction() == interactionId then
			self._promptController:SetActiveInteraction(nil)
		end
	end)
end

return InteractionPromptComponent
