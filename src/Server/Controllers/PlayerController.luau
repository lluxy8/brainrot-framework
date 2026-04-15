--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Currency = require(Shared.Constants.Currency)

local PlayerController = {}
PlayerController.__index = PlayerController

export type PlayerController = typeof(setmetatable(
	{} :: {
		_dataService: any,
		_economyService: any,
		_zoneService: any,
		_started: boolean,
	},
	PlayerController
))

function PlayerController.new(
	dataService: any,
	economyService: any,
	zoneService: any
): PlayerController
	local self = setmetatable({
		_dataService = dataService,
		_economyService = economyService,
		_zoneService = zoneService,
		_started = false,
	}, PlayerController)

	return self
end

function PlayerController:_syncAttributes(player: Player)
	local profile = self._dataService:GetOrCreateProfile(player)
	player:SetAttribute("Brainrot_ProfileVersion", profile.version)
	player:SetAttribute("Brainrot_Coins", self._economyService:GetBalance(player, Currency.Coins))

	local unlockedZones = self._zoneService:GetUnlockedZones(player)
	player:SetAttribute("Brainrot_UnlockedZoneCount", 0)
	local count = 0
	for _, unlocked in pairs(unlockedZones) do
		if unlocked then
			count += 1
		end
	end
	player:SetAttribute("Brainrot_UnlockedZoneCount", count)
end

function PlayerController:Start()
	if self._started then
		return
	end

	self._started = true
	for _, player in ipairs(Players:GetPlayers()) do
		self:_syncAttributes(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:_syncAttributes(player)
	end)
end

return PlayerController
