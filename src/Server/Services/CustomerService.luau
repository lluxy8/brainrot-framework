--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local CustomerDefinition = require(Shared.Gameplay.Customer.CustomerDefinition)
local SatisfactionRules = require(Shared.Gameplay.Customer.SatisfactionRules)
local Signal = require(Shared.Core.Signal)

type CustomerDefinitionType = CustomerDefinition.CustomerDefinition

export type ActiveCustomer = {
	id: string,
	customerTypeId: string,
	displayName: string,
	zoneId: string,
	spawnedAt: number,
	maxPatienceSeconds: number,
	rewardMultiplier: number,
}

export type CustomerCompletionResult = {
	customerId: string,
	score: number,
	tier: string,
	waitSeconds: number,
	mistakes: number,
}

local CustomerService = {}
CustomerService.__index = CustomerService

export type CustomerService = typeof(setmetatable(
	{} :: {
		_customers: { [string]: ActiveCustomer },
		CustomerSpawned: Signal.Signal,
		CustomerCompleted: Signal.Signal,
		CustomerRemoved: Signal.Signal,
	},
	CustomerService
))

function CustomerService.new(): CustomerService
	local self = setmetatable({
		_customers = {},
		CustomerSpawned = Signal.new(),
		CustomerCompleted = Signal.new(),
		CustomerRemoved = Signal.new(),
	}, CustomerService)

	return self
end

function CustomerService:Start()
	-- Intentionally empty. Spawn/despawn is driven by gameplay.
end

function CustomerService:SpawnCustomer(zoneId: string, customerTypeId: string?): ActiveCustomer
	local typeId = customerTypeId or "Regular"
	local definition: CustomerDefinitionType = CustomerDefinition.Resolve(typeId)

	local id = HttpService:GenerateGUID(false)
	local customer: ActiveCustomer = {
		id = id,
		customerTypeId = typeId,
		displayName = definition.displayName,
		zoneId = zoneId,
		spawnedAt = os.clock(),
		maxPatienceSeconds = definition.basePatienceSeconds,
		rewardMultiplier = definition.rewardMultiplier,
	}

	self._customers[id] = customer
	self.CustomerSpawned:Fire(customer)
	return customer
end

function CustomerService:GetCustomer(customerId: string): ActiveCustomer?
	return self._customers[customerId]
end

function CustomerService:GetActiveCustomers(): { [string]: ActiveCustomer }
	return table.clone(self._customers)
end

function CustomerService:CompleteCustomer(
	customerId: string,
	mistakes: number?
): (CustomerCompletionResult?, string?)
	local customer = self._customers[customerId]
	if not customer then
		return nil, "Customer does not exist"
	end

	local waitSeconds = os.clock() - customer.spawnedAt
	local mistakeCount = mistakes or 0
	local score =
		SatisfactionRules.CalculateScore(waitSeconds, customer.maxPatienceSeconds, mistakeCount)
	local tier = SatisfactionRules.GetTier(score)

	local result: CustomerCompletionResult = {
		customerId = customerId,
		score = score,
		tier = tier,
		waitSeconds = waitSeconds,
		mistakes = mistakeCount,
	}

	self._customers[customerId] = nil
	self.CustomerCompleted:Fire(customer, result)
	self.CustomerRemoved:Fire(customerId)
	return result, nil
end

function CustomerService:RemoveCustomer(customerId: string): boolean
	if not self._customers[customerId] then
		return false
	end

	self._customers[customerId] = nil
	self.CustomerRemoved:Fire(customerId)
	return true
end

return CustomerService
