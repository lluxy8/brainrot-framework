--!strict

local RegisterComponents = require(script.Bootstrap.RegisterComponents)
local RegisterServices = require(script.Bootstrap.RegisterServices)

local FrameworkServer = {}

type Runtime = {
	services: any,
	components: any,
}

local runtime: Runtime? = nil

function FrameworkServer.Start(): Runtime
	if runtime then
		return runtime
	end

	local services = RegisterServices()
	local components = RegisterComponents(services)
	runtime = {
		services = services,
		components = components,
	}

	return runtime
end

function FrameworkServer.GetRuntime(): Runtime?
	return runtime
end

function FrameworkServer.GetServiceRegistry(): any?
	local current = runtime
	if not current then
		return nil
	end

	return current.services
end

function FrameworkServer.GetComponentRegistry(): any?
	local current = runtime
	if not current then
		return nil
	end

	return current.components
end

return FrameworkServer
