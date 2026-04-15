--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Registry = require(Shared.Core.Registry)
local RemoteNames = require(Shared.Net.RemoteNames)
local Remotes = require(Shared.Constants.Remotes)

local CustomerService = require(script.Parent.Parent.Services.CustomerService)
local DataService = require(script.Parent.Parent.Services.DataService)
local EconomyService = require(script.Parent.Parent.Services.EconomyService)
local InteractionService = require(script.Parent.Parent.Services.InteractionService)
local InventoryService = require(script.Parent.Parent.Services.InventoryService)
local QuestService = require(script.Parent.Parent.Services.QuestService)
local RewardService = require(script.Parent.Parent.Services.RewardService)
local SessionService = require(script.Parent.Parent.Services.SessionService)
local StationService = require(script.Parent.Parent.Services.StationService)
local TaskService = require(script.Parent.Parent.Services.TaskService)
local UpgradeService = require(script.Parent.Parent.Services.UpgradeService)
local ZoneService = require(script.Parent.Parent.Services.ZoneService)

local activeRegistry: Registry.Registry? = nil

local function startServiceIfPresent(serviceObject: any)
	if type(serviceObject.Start) == "function" then
		serviceObject:Start()
	end
end

local function wireNetwork(
	dataService: any,
	interactionService: any,
	taskService: any,
	questService: any,
	inventoryService: any,
	upgradeService: any,
	zoneService: any,
	customerService: any,
	stationService: any
)
	local remoteMap = Remotes.EnsureAllEvents()

	local performInteractionRemote = remoteMap[RemoteNames.PerformInteraction]
	local interactionResultRemote = remoteMap[RemoteNames.InteractionResult]
	local purchaseUpgradeRemote = remoteMap[RemoteNames.PurchaseUpgrade]
	local upgradePurchaseResultRemote = remoteMap[RemoteNames.UpgradePurchaseResult]
	local unlockZoneRemote = remoteMap[RemoteNames.UnlockZone]
	local zoneUnlockResultRemote = remoteMap[RemoteNames.ZoneUnlockResult]
	local requestSnapshotRemote = remoteMap[RemoteNames.RequestSnapshot]
	local snapshotRemote = remoteMap[RemoteNames.Snapshot]
	local taskCompletedRemote = remoteMap[RemoteNames.TaskCompleted]
	local economyUpdatedRemote = remoteMap[RemoteNames.EconomyUpdated]
	local inventoryUpdatedRemote = remoteMap[RemoteNames.InventoryUpdated]
	local upgradePurchasedRemote = remoteMap[RemoteNames.UpgradePurchased]
	local zoneUnlockedRemote = remoteMap[RemoteNames.ZoneUnlocked]
	local questProgressedRemote = remoteMap[RemoteNames.QuestProgressed]
	local questCompletedRemote = remoteMap[RemoteNames.QuestCompleted]
	local customerSpawnedRemote = remoteMap[RemoteNames.CustomerSpawned]
	local customerCompletedRemote = remoteMap[RemoteNames.CustomerCompleted]
	local stationChangedRemote = remoteMap[RemoteNames.StationChanged]

	local function fireSnapshot(player: Player)
		local profile = dataService:GetProfileSnapshot(player)
		snapshotRemote:FireClient(player, {
			currencies = profile.economy,
			inventory = profile.inventory.items,
			upgrades = profile.upgrades.levels,
			unlockedZones = profile.zones.unlocked,
			quests = {
				progress = profile.quests.progress,
				completed = profile.quests.completed,
			},
		})
	end

	local function sendInteractionError(
		player: Player,
		requestId: string,
		interactionId: string,
		err: string
	)
		interactionResultRemote:FireClient(player, {
			requestId = requestId,
			ok = false,
			interactionId = interactionId,
			error = err,
			result = nil,
		})
	end

	local function sendUpgradeError(
		player: Player,
		requestId: string,
		upgradeId: string,
		err: string
	)
		upgradePurchaseResultRemote:FireClient(player, {
			requestId = requestId,
			ok = false,
			upgradeId = upgradeId,
			error = err,
			result = nil,
		})
	end

	local function sendZoneUnlockError(
		player: Player,
		requestId: string,
		zoneId: string,
		err: string
	)
		zoneUnlockResultRemote:FireClient(player, {
			requestId = requestId,
			ok = false,
			zoneId = zoneId,
			error = err,
			result = nil,
		})
	end

	performInteractionRemote.OnServerEvent:Connect(function(player: Player, payload: any)
		if type(payload) ~= "table" then
			sendInteractionError(player, "invalid", "", "Payload must be a table")
			return
		end

		local requestId = payload.requestId
		local interactionId = payload.interactionId
		if type(requestId) ~= "string" or requestId == "" then
			requestId = "invalid"
		end

		if type(interactionId) ~= "string" or interactionId == "" then
			sendInteractionError(player, requestId, "", "interactionId must be a non-empty string")
			return
		end

		local result, err = interactionService:PerformInteraction(player, interactionId)
		if err then
			sendInteractionError(player, requestId, interactionId, err)
			return
		end

		interactionResultRemote:FireClient(player, {
			requestId = requestId,
			ok = true,
			interactionId = interactionId,
			error = nil,
			result = result,
		})
	end)

	purchaseUpgradeRemote.OnServerEvent:Connect(function(player: Player, payload: any)
		if type(payload) ~= "table" then
			sendUpgradeError(player, "invalid", "", "Payload must be a table")
			return
		end

		local requestId = payload.requestId
		local upgradeId = payload.upgradeId
		if type(requestId) ~= "string" or requestId == "" then
			requestId = "invalid"
		end

		if type(upgradeId) ~= "string" or upgradeId == "" then
			sendUpgradeError(player, requestId, "", "upgradeId must be a non-empty string")
			return
		end

		local ok, err, result = upgradeService:PurchaseUpgrade(player, upgradeId)
		if not ok then
			sendUpgradeError(player, requestId, upgradeId, err or "Upgrade purchase failed")
			return
		end

		upgradePurchaseResultRemote:FireClient(player, {
			requestId = requestId,
			ok = true,
			upgradeId = upgradeId,
			error = nil,
			result = result,
		})
	end)

	unlockZoneRemote.OnServerEvent:Connect(function(player: Player, payload: any)
		if type(payload) ~= "table" then
			sendZoneUnlockError(player, "invalid", "", "Payload must be a table")
			return
		end

		local requestId = payload.requestId
		local zoneId = payload.zoneId
		if type(requestId) ~= "string" or requestId == "" then
			requestId = "invalid"
		end

		if type(zoneId) ~= "string" or zoneId == "" then
			sendZoneUnlockError(player, requestId, "", "zoneId must be a non-empty string")
			return
		end

		local ok, err, result = zoneService:UnlockZone(player, zoneId)
		if not ok then
			sendZoneUnlockError(player, requestId, zoneId, err or "Zone unlock failed")
			return
		end

		zoneUnlockResultRemote:FireClient(player, {
			requestId = requestId,
			ok = true,
			zoneId = zoneId,
			error = nil,
			result = result,
		})
	end)

	requestSnapshotRemote.OnServerEvent:Connect(function(player: Player)
		fireSnapshot(player)
	end)

	taskService.TaskCompleted:Connect(function(player: Player, completionResult: any)
		local reward = completionResult.reward
		taskCompletedRemote:FireClient(player, {
			taskId = completionResult.taskId,
			rewardAmount = reward.amount,
			balance = reward.newBalance,
			timesCompleted = completionResult.runResult.timesCompleted,
		})

		economyUpdatedRemote:FireClient(player, {
			currency = reward.currency,
			delta = reward.amount,
			balance = reward.newBalance,
			reason = ("TaskReward:%s"):format(completionResult.taskId),
		})
	end)

	inventoryService.ItemChanged:Connect(function(player: Player, payload: any)
		inventoryUpdatedRemote:FireClient(player, payload)
	end)

	upgradeService.UpgradePurchased:Connect(function(player: Player, payload: any)
		upgradePurchasedRemote:FireClient(player, payload)
		economyUpdatedRemote:FireClient(player, {
			currency = payload.currency,
			delta = -payload.cost,
			balance = payload.newBalance,
			reason = ("UpgradePurchase:%s"):format(payload.upgradeId),
		})
	end)

	zoneService.ZoneUnlocked:Connect(function(player: Player, payload: any)
		zoneUnlockedRemote:FireClient(player, payload)
		if payload.cost > 0 then
			economyUpdatedRemote:FireClient(player, {
				currency = payload.currency,
				delta = -payload.cost,
				balance = dataService:GetCurrencyBalance(player, payload.currency),
				reason = ("ZoneUnlock:%s"):format(payload.zoneId),
			})
		end
	end)

	questService.QuestProgressed:Connect(function(player: Player, progressPayload: any)
		questProgressedRemote:FireClient(player, progressPayload)
	end)

	questService.QuestCompleted:Connect(function(player: Player, questId: string)
		questCompletedRemote:FireClient(player, {
			questId = questId,
		})
	end)

	customerService.CustomerSpawned:Connect(function(customer: any)
		customerSpawnedRemote:FireAllClients({
			id = customer.id,
			customerTypeId = customer.customerTypeId,
			displayName = customer.displayName,
			zoneId = customer.zoneId,
		})
	end)

	customerService.CustomerCompleted:Connect(function(_customer: any, result: any)
		customerCompletedRemote:FireAllClients(result)
	end)

	stationService.StationChanged:Connect(function(payload: any)
		stationChangedRemote:FireAllClients(payload)
	end)
end

local function registerServices()
	if activeRegistry then
		return activeRegistry
	end

	local registry = Registry.new()

	local dataService = DataService.new()
	local economyService = EconomyService.new(dataService)
	local inventoryService = InventoryService.new(dataService)
	local zoneService = ZoneService.new(dataService, economyService)
	local stationService = StationService.new(zoneService)
	local upgradeService = UpgradeService.new(dataService, economyService)
	local rewardService = RewardService.new(economyService)
	rewardService:SetUpgradeService(upgradeService)
	local taskService = TaskService.new(dataService, rewardService)
	local questService = QuestService.new(dataService, taskService)
	local sessionService = SessionService.new(taskService)
	local interactionService = InteractionService.new(sessionService, stationService)
	local customerService = CustomerService.new()

	registry:Register("DataService", dataService)
	registry:Register("EconomyService", economyService)
	registry:Register("InventoryService", inventoryService)
	registry:Register("ZoneService", zoneService)
	registry:Register("StationService", stationService)
	registry:Register("UpgradeService", upgradeService)
	registry:Register("RewardService", rewardService)
	registry:Register("TaskService", taskService)
	registry:Register("QuestService", questService)
	registry:Register("SessionService", sessionService)
	registry:Register("InteractionService", interactionService)
	registry:Register("CustomerService", customerService)

	startServiceIfPresent(dataService)
	startServiceIfPresent(economyService)
	startServiceIfPresent(inventoryService)
	startServiceIfPresent(zoneService)
	startServiceIfPresent(stationService)
	startServiceIfPresent(upgradeService)
	startServiceIfPresent(rewardService)
	startServiceIfPresent(taskService)
	startServiceIfPresent(questService)
	startServiceIfPresent(sessionService)
	startServiceIfPresent(interactionService)
	startServiceIfPresent(customerService)

	wireNetwork(
		dataService,
		interactionService,
		taskService,
		questService,
		inventoryService,
		upgradeService,
		zoneService,
		customerService,
		stationService
	)

	activeRegistry = registry
	return registry
end

return registerServices
