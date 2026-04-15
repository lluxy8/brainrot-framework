--!strict

local EconomyService = {}
EconomyService.__index = EconomyService

export type EconomyService = typeof(setmetatable(
	{} :: {
		_dataService: any,
	},
	EconomyService
))

function EconomyService.new(dataService: any): EconomyService
	local self = setmetatable({
		_dataService = dataService,
	}, EconomyService)

	return self
end

function EconomyService:Start()
	-- Intentionally empty for now: DataService owns player profile lifecycle.
end

function EconomyService:GetBalance(player: Player, currencyCode: string): number
	return self._dataService:GetCurrencyBalance(player, currencyCode)
end

function EconomyService:AddCurrency(
	player: Player,
	currencyCode: string,
	amount: number,
	_reason: string?
): number
	if amount == 0 then
		return self:GetBalance(player, currencyCode)
	end

	return self._dataService:AddCurrency(player, currencyCode, amount)
end

function EconomyService:SpendCurrency(
	player: Player,
	currencyCode: string,
	amount: number
): (boolean, number)
	assert(amount >= 0, "SpendCurrency expects amount >= 0")

	local currentBalance = self:GetBalance(player, currencyCode)
	if currentBalance < amount then
		return false, currentBalance
	end

	local nextBalance = self._dataService:AddCurrency(player, currencyCode, -amount)
	return true, nextBalance
end

return EconomyService
