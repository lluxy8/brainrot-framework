--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Signal = require(Shared.Core.Signal)
local UpgradeConfig = require(Shared.Config.UpgradeConfig)
local UpgradeDefinitionModule = require(Shared.Gameplay.Upgrade.UpgradeDefinition)
local UpgradeEffectResolver = require(Shared.Gameplay.Upgrade.UpgradeEffectResolver)
type UpgradeDefinition = UpgradeDefinitionModule.UpgradeDefinition

export type UpgradePurchasePayload = {
	upgradeId: string,
	newLevel: number,
	cost: number,
	currency: string,
	newBalance: number,
}

local UpgradeService = {}
UpgradeService.__index = UpgradeService

export type UpgradeService = typeof(setmetatable(
	{} :: {
		_dataService: any,
		_economyService: any,
		_upgrades: { [string]: UpgradeDefinition },
		UpgradePurchased: Signal.Signal,
	},
	UpgradeService
))

function UpgradeService.new(dataService: any, economyService: any): UpgradeService
	local self = setmetatable({
		_dataService = dataService,
		_economyService = economyService,
		_upgrades = UpgradeConfig.Upgrades,
		UpgradePurchased = Signal.new(),
	}, UpgradeService)

	return self
end

function UpgradeService:Start()
	-- Intentionally empty for now.
end

function UpgradeService:GetDefinitions(): { [string]: UpgradeDefinition }
	return self._upgrades
end

function UpgradeService:TryResolve(upgradeId: string): UpgradeDefinition?
	return self._upgrades[upgradeId]
end

function UpgradeService:GetUpgradeLevel(player: Player, upgradeId: string): number
	return self._dataService:GetUpgradeLevel(player, upgradeId)
end

function UpgradeService:GetUpgradeCost(player: Player, upgradeId: string): (number?, string?)
	local definition = self:TryResolve(upgradeId)
	if not definition then
		return nil, string.format("Upgrade '%s' is not defined", upgradeId)
	end

	local currentLevel = self:GetUpgradeLevel(player, upgradeId)
	if currentLevel >= definition.maxLevel then
		return nil, "Upgrade is already at max level"
	end

	local cost = UpgradeEffectResolver.GetUpgradeCost(definition, currentLevel)
	return cost, nil
end

function UpgradeService:PurchaseUpgrade(
	player: Player,
	upgradeId: string
): (boolean, string?, UpgradePurchasePayload?)
	local definition = self:TryResolve(upgradeId)
	if not definition then
		return false, string.format("Upgrade '%s' is not defined", upgradeId), nil
	end

	local currentLevel = self:GetUpgradeLevel(player, upgradeId)
	if currentLevel >= definition.maxLevel then
		return false, "Upgrade is already at max level", nil
	end

	local cost = UpgradeEffectResolver.GetUpgradeCost(definition, currentLevel)
	local spent, nextBalance = self._economyService:SpendCurrency(player, definition.currency, cost)
	if not spent then
		return false, "Not enough currency", nil
	end

	local newLevel = self._dataService:SetUpgradeLevel(player, upgradeId, currentLevel + 1)
	local payload: UpgradePurchasePayload = {
		upgradeId = upgradeId,
		newLevel = newLevel,
		cost = cost,
		currency = definition.currency,
		newBalance = nextBalance,
	}

	self.UpgradePurchased:Fire(player, payload)
	return true, nil, payload
end

function UpgradeService:GetTaskRewardMultiplier(player: Player): number
	local upgradeLevels = self._dataService:GetUpgradeLevels(player)
	return UpgradeEffectResolver.GetTaskRewardMultiplier(upgradeLevels, self._upgrades)
end

return UpgradeService
