--!strict

local Currency = require(script.Parent.Parent.Constants.Currency)

local EconomyConfig = {
	TaskRewardMultiplier = 1,
	RepeatCompletionBonus = 2,
	StartingBalances = {
		[Currency.Coins] = 0,
	},
}

return table.freeze(EconomyConfig)
