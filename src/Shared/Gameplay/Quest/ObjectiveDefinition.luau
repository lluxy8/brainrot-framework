--!strict

local ObjectiveDefinition = {}

export type ObjectiveDefinition = {
	id: string,
	taskId: string,
	requiredCount: number,
}

function ObjectiveDefinition.isValid(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local data = value :: any
	return type(data.id) == "string"
		and data.id ~= ""
		and type(data.taskId) == "string"
		and data.taskId ~= ""
		and type(data.requiredCount) == "number"
		and data.requiredCount >= 1
end

return ObjectiveDefinition
