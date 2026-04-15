--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Timer = require(Shared.Core.Timer)

local RoundController = {}
RoundController.__index = RoundController

export type RoundController = typeof(setmetatable(
	{} :: {
		_customerService: any,
		_zoneService: any,
		_spawnTimer: Timer.Timer?,
		_started: boolean,
	},
	RoundController
))

function RoundController.new(customerService: any, zoneService: any): RoundController
	local self = setmetatable({
		_customerService = customerService,
		_zoneService = zoneService,
		_spawnTimer = nil,
		_started = false,
	}, RoundController)

	return self
end

function RoundController:_spawnCustomerWave()
	-- Framework default: keep StarterZone populated. Projects can replace this strategy.
	self._customerService:SpawnCustomer("StarterZone", nil)
end

function RoundController:Start()
	if self._started then
		return
	end

	self._started = true
	local timer = Timer.new(15)
	self._spawnTimer = timer
	timer.Ticked:Connect(function()
		self:_spawnCustomerWave()
	end)
	timer:Start()
end

return RoundController
