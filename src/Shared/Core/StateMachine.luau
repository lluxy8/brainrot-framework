--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)

type TransitionRules = { [string]: { [string]: boolean } }

local StateMachine = {}
StateMachine.__index = StateMachine

export type StateMachine = typeof(setmetatable(
	{} :: {
		_state: string,
		_rules: TransitionRules,
		StateChanged: Signal.Signal,
	},
	StateMachine
))

function StateMachine.new(initialState: string, transitionRules: TransitionRules): StateMachine
	assert(initialState ~= "", "StateMachine initialState is required")

	local self = setmetatable({
		_state = initialState,
		_rules = transitionRules,
		StateChanged = Signal.new(),
	}, StateMachine)

	return self
end

function StateMachine:GetState(): string
	return self._state
end

function StateMachine:CanTransition(nextState: string): boolean
	local rulesForCurrent = self._rules[self._state]
	if not rulesForCurrent then
		return false
	end

	return rulesForCurrent[nextState] == true
end

function StateMachine:Transition(nextState: string): (boolean, string?)
	if nextState == self._state then
		return true, nil
	end

	if not self:CanTransition(nextState) then
		return false, string.format("Invalid transition from '%s' to '%s'", self._state, nextState)
	end

	local previousState = self._state
	self._state = nextState
	self.StateChanged:Fire(previousState, nextState)
	return true, nil
end

function StateMachine:Destroy()
	self.StateChanged:Destroy()
end

return StateMachine
