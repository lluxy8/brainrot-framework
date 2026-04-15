--!strict

local CustomerComponent = {}
CustomerComponent.__index = CustomerComponent

export type CustomerComponent = typeof(setmetatable(
	{} :: {
		_customerService: any,
	},
	CustomerComponent
))

function CustomerComponent.new(customerService: any): CustomerComponent
	local self = setmetatable({
		_customerService = customerService,
	}, CustomerComponent)

	return self
end

function CustomerComponent:Start()
	-- Intentionally empty.
end

function CustomerComponent:Spawn(zoneId: string, customerTypeId: string?): any
	return self._customerService:SpawnCustomer(zoneId, customerTypeId)
end

function CustomerComponent:Complete(customerId: string, mistakes: number?): (any?, string?)
	return self._customerService:CompleteCustomer(customerId, mistakes)
end

return CustomerComponent
