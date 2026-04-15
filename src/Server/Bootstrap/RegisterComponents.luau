--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Registry = require(Shared.Core.Registry)

local CustomerComponent = require(script.Parent.Parent.Components.NPC.CustomerComponent)
local DeliveryStationComponent =
	require(script.Parent.Parent.Components.Stations.DeliveryStationComponent)
local NPCController = require(script.Parent.Parent.Controllers.NPCController)
local PlayerController = require(script.Parent.Parent.Controllers.PlayerController)
local QueueStationComponent =
	require(script.Parent.Parent.Components.Stations.QueueStationComponent)
local RewardZoneComponent = require(script.Parent.Parent.Components.Zones.RewardZoneComponent)
local RoundController = require(script.Parent.Parent.Controllers.RoundController)
local UnlockZoneComponent = require(script.Parent.Parent.Components.Zones.UnlockZoneComponent)
local WorkZoneComponent = require(script.Parent.Parent.Components.Zones.WorkZoneComponent)
local WorkstationComponent = require(script.Parent.Parent.Components.Stations.WorkstationComponent)

local activeRegistry: Registry.Registry? = nil

local function startIfPresent(target: any)
	if type(target.Start) == "function" then
		target:Start()
	end
end

local function registerComponents(serviceRegistry: any)
	if activeRegistry then
		return activeRegistry
	end

	local dataService = serviceRegistry:Resolve("DataService")
	local economyService = serviceRegistry:Resolve("EconomyService")
	local zoneService = serviceRegistry:Resolve("ZoneService")
	local stationService = serviceRegistry:Resolve("StationService")
	local interactionService = serviceRegistry:Resolve("InteractionService")
	local customerService = serviceRegistry:Resolve("CustomerService")

	local registry = Registry.new()

	local playerController = PlayerController.new(dataService, economyService, zoneService)
	local npcController = NPCController.new(customerService)
	local roundController = RoundController.new(customerService, zoneService)

	local workstationComponent = WorkstationComponent.new(interactionService, "WashCarInteract")
	local deliveryStationComponent =
		DeliveryStationComponent.new(interactionService, "ServeCustomerInteract")
	local queueStationComponent = QueueStationComponent.new(stationService)
	local rewardZoneComponent = RewardZoneComponent.new(economyService, 25, 5)
	local unlockZoneComponent = UnlockZoneComponent.new(zoneService)
	local workZoneComponent = WorkZoneComponent.new(zoneService)
	local customerComponent = CustomerComponent.new(customerService)

	registry:Register("PlayerController", playerController)
	registry:Register("NPCController", npcController)
	registry:Register("RoundController", roundController)
	registry:Register("WorkstationComponent", workstationComponent)
	registry:Register("DeliveryStationComponent", deliveryStationComponent)
	registry:Register("QueueStationComponent", queueStationComponent)
	registry:Register("RewardZoneComponent", rewardZoneComponent)
	registry:Register("UnlockZoneComponent", unlockZoneComponent)
	registry:Register("WorkZoneComponent", workZoneComponent)
	registry:Register("CustomerComponent", customerComponent)

	startIfPresent(playerController)
	startIfPresent(npcController)
	startIfPresent(roundController)
	startIfPresent(workstationComponent)
	startIfPresent(deliveryStationComponent)
	startIfPresent(queueStationComponent)
	startIfPresent(rewardZoneComponent)
	startIfPresent(unlockZoneComponent)
	startIfPresent(workZoneComponent)
	startIfPresent(customerComponent)

	activeRegistry = registry
	return registry
end

return registerComponents
