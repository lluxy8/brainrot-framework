--!strict

local Currency = require(script.Parent.Parent.Parent.Constants.Currency)

export type CurrencyDefinition = {
	id: string,
	displayName: string,
	symbol: string,
	defaultAmount: number,
}

local definitions: { [string]: CurrencyDefinition } = {
	[Currency.Coins] = {
		id = Currency.Coins,
		displayName = "Coins",
		symbol = "$",
		defaultAmount = 0,
	},
}

return table.freeze(definitions)
