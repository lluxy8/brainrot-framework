--!strict

local TaskDefinition = {}

export type TaskDefinition = {
	id: string,
	displayName: string,
	currency: string,
	baseReward: number,
	requiredProgress: number,
}

function TaskDefinition.isValid(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local record = value :: any
	return type(record.id) == "string"
		and record.id ~= ""
		and type(record.displayName) == "string"
		and type(record.currency) == "string"
		and type(record.baseReward) == "number"
		and type(record.requiredProgress) == "number"
		and record.requiredProgress >= 1
end

return TaskDefinition
