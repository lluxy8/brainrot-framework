--!strict

local NumberUtil = {}

function NumberUtil.Clamp(value: number, minValue: number, maxValue: number): number
	return math.clamp(value, minValue, maxValue)
end

function NumberUtil.Round(value: number, decimals: number?): number
	local decimalPlaces = decimals or 0
	local multiplier = 10 ^ decimalPlaces
	return math.floor(value * multiplier + 0.5) / multiplier
end

function NumberUtil.Lerp(fromValue: number, toValue: number, alpha: number): number
	return fromValue + (toValue - fromValue) * alpha
end

function NumberUtil.IsFinite(value: number): boolean
	return value == value and value ~= math.huge and value ~= -math.huge
end

function NumberUtil.ApproxEqual(left: number, right: number, epsilon: number?): boolean
	local tolerance = epsilon or 1e-4
	return math.abs(left - right) <= tolerance
end

return NumberUtil
