--!strict

local UpgradeController = {}
UpgradeController.__index = UpgradeController

export type UpgradeController = typeof(setmetatable(
	{} :: {
		_feedbackService: any,
	},
	UpgradeController
))

function UpgradeController.new(feedbackService: any): UpgradeController
	local self = setmetatable({
		_feedbackService = feedbackService,
	}, UpgradeController)

	return self
end

function UpgradeController:Start()
	self._feedbackService.UpgradePurchaseResultReceived:Connect(function(payload: any)
		if type(payload) == "table" and payload.ok == false then
			warn(string.format("[Upgrade] Purchase failed: %s", tostring(payload.error)))
		end
	end)
end

function UpgradeController:Purchase(upgradeId: string): string
	return self._feedbackService:RequestUpgradePurchase(upgradeId)
end

function UpgradeController:GetLevels(): { [string]: number }
	return self._feedbackService:GetUpgradeLevels()
end

return UpgradeController
