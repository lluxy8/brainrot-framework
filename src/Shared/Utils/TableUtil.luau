--!strict

local TableUtil = {}

function TableUtil.ShallowClone<T>(input: { [any]: T }): { [any]: T }
	return table.clone(input)
end

function TableUtil.DeepClone(input: any): any
	if type(input) ~= "table" then
		return input
	end

	local output = {}
	for key, value in pairs(input) do
		output[TableUtil.DeepClone(key)] = TableUtil.DeepClone(value)
	end

	return output
end

function TableUtil.Merge<T>(base: { [string]: T }, overrides: { [string]: T }): { [string]: T }
	local merged = table.clone(base)
	for key, value in pairs(overrides) do
		merged[key] = value
	end

	return merged
end

function TableUtil.Values<T>(input: { [any]: T }): { T }
	local output: { T } = {}
	for _, value in pairs(input) do
		table.insert(output, value)
	end

	return output
end

function TableUtil.Keys(input: { [any]: any }): { any }
	local output = {}
	for key in pairs(input) do
		table.insert(output, key)
	end

	return output
end

function TableUtil.Count(input: { [any]: any }): number
	local count = 0
	for _ in pairs(input) do
		count += 1
	end
	return count
end

return TableUtil
