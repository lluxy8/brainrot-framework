--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local ItemDefinition = require(Shared.Gameplay.Inventory.ItemDefinition)
local Signal = require(Shared.Core.Signal)

export type ItemChangedPayload = {
	itemId: string,
	delta: number,
	newCount: number,
}

local InventoryService = {}
InventoryService.__index = InventoryService

export type InventoryService = typeof(setmetatable(
	{} :: {
		_dataService: any,
		ItemChanged: Signal.Signal,
	},
	InventoryService
))

function InventoryService.new(dataService: any): InventoryService
	local self = setmetatable({
		_dataService = dataService,
		ItemChanged = Signal.new(),
	}, InventoryService)

	return self
end

function InventoryService:Start()
	-- Intentionally empty for now.
end

function InventoryService:GetItems(player: Player): { [string]: number }
	return self._dataService:GetInventoryItems(player)
end

function InventoryService:GetItemCount(player: Player, itemId: string): number
	return self._dataService:GetItemCount(player, itemId)
end

function InventoryService:HasItem(player: Player, itemId: string, amount: number?): boolean
	local requiredAmount = amount or 1
	return self:GetItemCount(player, itemId) >= requiredAmount
end

function InventoryService:AddItem(
	player: Player,
	itemId: string,
	amount: number
): (number?, string?)
	if amount <= 0 then
		return nil, "Amount must be greater than zero"
	end

	if not ItemDefinition.TryResolve(itemId) then
		return nil, string.format("Item '%s' is not defined", itemId)
	end

	local nextCount = self._dataService:AddInventoryItem(player, itemId, amount)
	self.ItemChanged:Fire(
		player,
		{
			itemId = itemId,
			delta = amount,
			newCount = nextCount,
		} :: ItemChangedPayload
	)

	return nextCount, nil
end

function InventoryService:RemoveItem(
	player: Player,
	itemId: string,
	amount: number
): (boolean, number, string?)
	if amount <= 0 then
		return false, self:GetItemCount(player, itemId), "Amount must be greater than zero"
	end

	local removed, nextCount = self._dataService:RemoveInventoryItem(player, itemId, amount)
	if not removed then
		return false, nextCount, "Not enough items"
	end

	self.ItemChanged:Fire(
		player,
		{
			itemId = itemId,
			delta = -amount,
			newCount = nextCount,
		} :: ItemChangedPayload
	)

	return true, nextCount, nil
end

return InventoryService
