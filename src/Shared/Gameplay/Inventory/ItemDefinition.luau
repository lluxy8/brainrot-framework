--!strict

local ItemDefinition = {}

export type ItemDefinition = {
	id: string,
	displayName: string,
	maxStack: number,
}

local catalog: { [string]: ItemDefinition } = {
	Sponge = {
		id = "Sponge",
		displayName = "Sponge",
		maxStack = 99,
	},
	Soap = {
		id = "Soap",
		displayName = "Soap",
		maxStack = 99,
	},
	PremiumWax = {
		id = "PremiumWax",
		displayName = "Premium Wax",
		maxStack = 25,
	},
}

function ItemDefinition.TryResolve(itemId: string): ItemDefinition?
	return catalog[itemId]
end

function ItemDefinition.Resolve(itemId: string): ItemDefinition
	local definition = ItemDefinition.TryResolve(itemId)
	if not definition then
		error(string.format("Item '%s' is not defined", itemId))
	end

	return definition
end

function ItemDefinition.GetAll(): { [string]: ItemDefinition }
	return catalog
end

return ItemDefinition
