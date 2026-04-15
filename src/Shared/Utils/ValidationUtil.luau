--!strict

local ValidationUtil = {}

function ValidationUtil.IsNonEmptyString(value: any): boolean
	return type(value) == "string" and value ~= ""
end

function ValidationUtil.IsPositiveInteger(value: any): boolean
	return type(value) == "number" and value >= 1 and math.floor(value) == value
end

function ValidationUtil.IsFiniteNumber(value: any): boolean
	if type(value) ~= "number" then
		return false
	end

	return value == value and value ~= math.huge and value ~= -math.huge
end

function ValidationUtil.Assert(condition: boolean, message: string)
	if not condition then
		error(message)
	end
end

return ValidationUtil
