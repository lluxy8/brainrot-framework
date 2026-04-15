--!strict

local InventoryTypes = {}

export type ItemCounts = { [string]: number }
export type InventorySnapshot = {
	items: ItemCounts,
}

return InventoryTypes
