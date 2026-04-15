--!strict

local WorkstationComponent = {}
WorkstationComponent.__index = WorkstationComponent

export type WorkstationComponent = typeof(setmetatable(
	{} :: {
		_interactionService: any,
		_defaultInteractionId: string,
	},
	WorkstationComponent
))

function WorkstationComponent.new(
	interactionService: any,
	defaultInteractionId: string?
): WorkstationComponent
	local self = setmetatable({
		_interactionService = interactionService,
		_defaultInteractionId = defaultInteractionId or "WashCarInteract",
	}, WorkstationComponent)

	return self
end

function WorkstationComponent:Start()
	-- Intentionally empty. Use Interact from game-specific prompts/buttons.
end

function WorkstationComponent:Interact(player: Player, interactionId: string?): (any?, string?)
	local selectedInteraction = interactionId or self._defaultInteractionId
	return self._interactionService:PerformInteraction(player, selectedInteraction)
end

return WorkstationComponent
