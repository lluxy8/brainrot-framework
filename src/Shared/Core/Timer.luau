--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)

local Timer = {}
Timer.__index = Timer

export type Timer = typeof(setmetatable(
	{} :: {
		_intervalSeconds: number,
		_repeatCount: number,
		_elapsedCount: number,
		_running: boolean,
		Ticked: Signal.Signal,
		Completed: Signal.Signal,
	},
	Timer
))

function Timer.new(intervalSeconds: number, repeatCount: number?): Timer
	assert(intervalSeconds > 0, "Timer interval must be > 0")

	local self = setmetatable({
		_intervalSeconds = intervalSeconds,
		_repeatCount = repeatCount or -1,
		_elapsedCount = 0,
		_running = false,
		Ticked = Signal.new(),
		Completed = Signal.new(),
	}, Timer)

	return self
end

function Timer:IsRunning(): boolean
	return self._running
end

function Timer:GetElapsedCount(): number
	return self._elapsedCount
end

function Timer:Start()
	if self._running then
		return
	end

	self._running = true
	task.spawn(function()
		while self._running do
			task.wait(self._intervalSeconds)
			if not self._running then
				break
			end

			self._elapsedCount += 1
			self.Ticked:Fire(self._elapsedCount)

			if self._repeatCount >= 0 and self._elapsedCount >= self._repeatCount then
				self._running = false
				self.Completed:Fire(self._elapsedCount)
				break
			end
		end
	end)
end

function Timer:Stop()
	self._running = false
end

function Timer:Reset(startImmediately: boolean?)
	self:Stop()
	self._elapsedCount = 0
	if startImmediately then
		self:Start()
	end
end

function Timer:Destroy()
	self:Stop()
	self.Ticked:Destroy()
	self.Completed:Destroy()
end

return Timer
