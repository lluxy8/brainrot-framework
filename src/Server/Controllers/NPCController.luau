--!strict

local NPCController = {}
NPCController.__index = NPCController

export type NPCController = typeof(setmetatable(
	{} :: {
		_customerService: any,
		_activeCount: number,
	},
	NPCController
))

function NPCController.new(customerService: any): NPCController
	local self = setmetatable({
		_customerService = customerService,
		_activeCount = 0,
	}, NPCController)

	return self
end

function NPCController:GetActiveCount(): number
	return self._activeCount
end

function NPCController:Start()
	self._customerService.CustomerSpawned:Connect(function()
		self._activeCount += 1
	end)

	self._customerService.CustomerRemoved:Connect(function()
		self._activeCount = math.max(0, self._activeCount - 1)
	end)
end

return NPCController
