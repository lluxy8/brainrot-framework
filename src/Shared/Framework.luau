--!strict

local Framework = {}

Framework.Version = "0.2.2"

Framework.RemoteNames = require(script.Net.RemoteNames)
Framework.PacketTypes = require(script.Net.PacketTypes)
Framework.Remotes = require(script.Constants.Remotes)
Framework.Currency = require(script.Constants.Currency)
Framework.TaskState = require(script.Constants.TaskState)
Framework.StationState = require(script.Constants.StationState)

Framework.TaskConfig = require(script.Config.TaskConfig)
Framework.UpgradeConfig = require(script.Config.UpgradeConfig)
Framework.ZoneConfig = require(script.Config.ZoneConfig)

function Framework.GetVersion(): string
	return Framework.Version
end

return Framework
