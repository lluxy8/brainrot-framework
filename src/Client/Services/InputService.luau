--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)

local InputService = {}
InputService.__index = InputService

export type InputService = typeof(setmetatable(
	{} :: {
		_started: boolean,
		InteractionPressed: Signal.Signal,
	},
	InputService
))

function InputService.new(): InputService
	local self = setmetatable({
		_started = false,
		InteractionPressed = Signal.new(),
	}, InputService)

	return self
end

function InputService:Start()
	if self._started then
		return
	end

	self._started = true
	UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
			return
		end

		if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.ButtonR2 then
			self.InteractionPressed:Fire()
		end
	end)
end

return InputService
