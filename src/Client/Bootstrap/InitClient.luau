--!strict

local RegisterControllers = require(script.Parent.RegisterControllers)

local function initClient()
	return RegisterControllers()
end

return initClient
