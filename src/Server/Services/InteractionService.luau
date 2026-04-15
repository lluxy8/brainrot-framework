--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local InteractionDefinition = require(Shared.Gameplay.Interaction.InteractionDefinition)
local InteractionValidator = require(Shared.Gameplay.Interaction.InteractionValidator)
local Signal = require(Shared.Core.Signal)

export type InteractionPerformedPayload = {
	interactionId: string,
	taskId: string?,
}

local InteractionService = {}
InteractionService.__index = InteractionService

export type InteractionService = typeof(setmetatable(
	{} :: {
		_sessionService: any,
		_stationService: any,
		_lastInteractionByPlayer: { [number]: { [string]: number } },
		InteractionPerformed: Signal.Signal,
	},
	InteractionService
))

function InteractionService.new(sessionService: any, stationService: any): InteractionService
	local self = setmetatable({
		_sessionService = sessionService,
		_stationService = stationService,
		_lastInteractionByPlayer = {},
		InteractionPerformed = Signal.new(),
	}, InteractionService)

	return self
end

function InteractionService:Start()
	-- Intentionally empty. Invoked by gameplay inputs.
end

function InteractionService:_isOnCooldown(
	player: Player,
	interactionId: string,
	cooldownSeconds: number
): (boolean, number)
	local now = os.clock()
	local playerCooldowns = self._lastInteractionByPlayer[player.UserId]
	if not playerCooldowns then
		playerCooldowns = {}
		self._lastInteractionByPlayer[player.UserId] = playerCooldowns
	end

	local lastInteractionAt = playerCooldowns[interactionId] or 0
	local elapsed = now - lastInteractionAt
	if elapsed < cooldownSeconds then
		return true, cooldownSeconds - elapsed
	end

	playerCooldowns[interactionId] = now
	return false, 0
end

function InteractionService:PerformInteraction(
	player: Player,
	interactionId: string
): (any?, string?)
	local valid, validationError = InteractionValidator.Validate(interactionId)
	if not valid then
		return nil, validationError
	end

	local definition = InteractionDefinition.Resolve(interactionId)
	local onCooldown, remaining =
		self:_isOnCooldown(player, interactionId, definition.cooldownSeconds)
	if onCooldown then
		return nil, string.format("Interaction cooldown: %.2fs", remaining)
	end

	if definition.stationId then
		local stationStarted, stationError =
			self._stationService:BeginUse(player, definition.stationId)
		if not stationStarted then
			return nil, stationError
		end
	end

	local result = nil
	local completionError = nil
	if definition.taskId then
		result, completionError =
			self._sessionService:CompleteTaskForPlayer(player, definition.taskId)
	end

	if definition.stationId then
		self._stationService:ReleaseStation(definition.stationId)
	end

	if completionError then
		return nil, completionError
	end

	self.InteractionPerformed:Fire(
		player,
		{
			interactionId = interactionId,
			taskId = definition.taskId,
		} :: InteractionPerformedPayload
	)

	return result, nil
end

return InteractionService
