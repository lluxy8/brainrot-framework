--!strict

local InteractionDefinition = require(script.Parent.InteractionDefinition)
local InteractionTypes = require(script.Parent.InteractionTypes)

local validTypes = {
	[InteractionTypes.Click] = true,
	[InteractionTypes.Hold] = true,
	[InteractionTypes.Proximity] = true,
}

local InteractionValidator = {}

function InteractionValidator.Validate(interactionId: string): (boolean, string?)
	local definition = InteractionDefinition.TryResolve(interactionId)
	if not definition then
		return false, string.format("Interaction '%s' does not exist", interactionId)
	end

	if validTypes[definition.interactionType] ~= true then
		return false,
			string.format(
				"Interaction '%s' has invalid type '%s'",
				interactionId,
				definition.interactionType
			)
	end

	if definition.cooldownSeconds < 0 then
		return false, string.format("Interaction '%s' has negative cooldown", interactionId)
	end

	return true, nil
end

return InteractionValidator
