--!strict

local ShopController = {}
ShopController.__index = ShopController

export type ShopController = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
	},
	ShopController
))

function ShopController.new(feedbackService: any): ShopController
	local self = setmetatable({
		_feedbackService = feedbackService,
	}, ShopController)

	return self
end

function ShopController:Start()
	self._feedbackService.ZoneUnlockResultReceived:Connect(function(payload: any)
		if type(payload) == "table" and payload.ok == false then
			warn(string.format("[Shop] Zone unlock failed: %s", tostring(payload.error)))
		end
	end)
end

function ShopController:RequestZoneUnlock(zoneId: string): string
	return self._feedbackService:RequestZoneUnlock(zoneId)
end

return ShopController
