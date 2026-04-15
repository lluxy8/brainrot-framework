--!strict

local RegisterControllers = require(script.Bootstrap.RegisterControllers)

local FrameworkClient = {}

local registry: any? = nil

function FrameworkClient.Start(): any
	if registry then
		return registry
	end

	registry = RegisterControllers()
	return registry
end

function FrameworkClient.GetRegistry(): any?
	return registry
end

return FrameworkClient
