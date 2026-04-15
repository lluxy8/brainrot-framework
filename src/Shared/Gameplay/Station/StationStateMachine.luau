--!strict

local StationState = require(script.Parent.Parent.Parent.Constants.StationState)

local allowedTransitions = {
	[StationState.Idle] = {
		[StationState.Reserved] = true,
		[StationState.InUse] = true,
	},
	[StationState.Reserved] = {
		[StationState.Idle] = true,
		[StationState.InUse] = true,
	},
	[StationState.InUse] = {
		[StationState.Idle] = true,
		[StationState.Reserved] = true,
	},
}

local StationStateMachine = {}

function StationStateMachine.CanTransition(fromState: string, toState: string): boolean
	local fromRules = allowedTransitions[fromState]
	if not fromRules then
		return false
	end

	return fromRules[toState] == true
end

return StationStateMachine
