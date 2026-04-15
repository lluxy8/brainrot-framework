--!strict

local RegisterComponents = require(script.Parent.RegisterComponents)
local RegisterServices = require(script.Parent.RegisterServices)

local function initServer()
	local registry = RegisterServices()
	RegisterComponents(registry)
	return registry
end

return initServer
