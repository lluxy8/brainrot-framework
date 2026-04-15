--!strict

type ValueStore = { [string]: any }

local Registry = {}
Registry.__index = Registry

export type Registry = typeof(setmetatable({} :: { _values: ValueStore }, Registry))

function Registry.new(): Registry
	local self = setmetatable({
		_values = {},
	}, Registry)

	return self
end

function Registry:Register(name: string, value: any): any
	assert(name ~= "", "Registry:Register expects a non-empty name")

	if self._values[name] ~= nil then
		error(string.format("Registry already contains '%s'", name))
	end

	self._values[name] = value
	return value
end

function Registry:Has(name: string): boolean
	return self._values[name] ~= nil
end

function Registry:TryResolve(name: string): any?
	return self._values[name]
end

function Registry:Resolve(name: string): any
	local value = self._values[name]
	if value == nil then
		error(string.format("Registry is missing '%s'", name))
	end

	return value
end

function Registry:Snapshot(): ValueStore
	return table.clone(self._values)
end

return Registry
