--!strict

local DeliveryStationComponent = {}
DeliveryStationComponent.__index = DeliveryStationComponent

export type DeliveryStationComponent = typeof(setmetatable(
	{} :: {
		_interactionService: any,
		_defaultInteractionId: string,
	},
	DeliveryStationComponent
))

function DeliveryStationComponent.new(
	interactionService: any,
	defaultInteractionId: string?
): DeliveryStationComponent
	local self = setmetatable({
		_interactionService = interactionService,
		_defaultInteractionId = defaultInteractionId or "ServeCustomerInteract",
	}, DeliveryStationComponent)

	return self
end

function DeliveryStationComponent:Start()
	-- Intentionally empty. Bound by game scripts/UI.
end

function DeliveryStationComponent:Deliver(player: Player, interactionId: string?): (any?, string?)
	local selectedInteraction = interactionId or self._defaultInteractionId
	return self._interactionService:PerformInteraction(player, selectedInteraction)
end

return DeliveryStationComponent
