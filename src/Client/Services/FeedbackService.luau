--!strict

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local RemoteNames = require(Shared.Net.RemoteNames)
local Remotes = require(Shared.Constants.Remotes)
local Signal = require(Shared.Core.Signal)

local function deepClone(value: any): any
	if type(value) ~= "table" then
		return value
	end

	local copy = {}
	for key, nested in pairs(value) do
		copy[deepClone(key)] = deepClone(nested)
	end
	return copy
end

local FeedbackService = {}
FeedbackService.__index = FeedbackService

export type FeedbackService = typeof(setmetatable(
	{} :: {
		_started: boolean,
		_performInteractionRemote: RemoteEvent?,
		_purchaseUpgradeRemote: RemoteEvent?,
		_unlockZoneRemote: RemoteEvent?,
		_requestSnapshotRemote: RemoteEvent?,
		_balancesByCurrency: { [string]: number },
		_inventoryItems: { [string]: number },
		_upgradeLevels: { [string]: number },
		_unlockedZones: { [string]: boolean },
		_questProgress: { [string]: { [string]: number } },
		_questCompleted: { [string]: boolean },
		InteractionResultReceived: Signal.Signal,
		TaskCompletedReceived: Signal.Signal,
		EconomyUpdatedReceived: Signal.Signal,
		InventoryUpdatedReceived: Signal.Signal,
		UpgradePurchasedReceived: Signal.Signal,
		UpgradePurchaseResultReceived: Signal.Signal,
		ZoneUnlockedReceived: Signal.Signal,
		ZoneUnlockResultReceived: Signal.Signal,
		QuestProgressedReceived: Signal.Signal,
		QuestCompletedReceived: Signal.Signal,
		SnapshotReceived: Signal.Signal,
		CustomerSpawnedReceived: Signal.Signal,
		CustomerCompletedReceived: Signal.Signal,
		StationChangedReceived: Signal.Signal,
	},
	FeedbackService
))

function FeedbackService.new(): FeedbackService
	local self = setmetatable({
		_started = false,
		_performInteractionRemote = nil,
		_purchaseUpgradeRemote = nil,
		_unlockZoneRemote = nil,
		_requestSnapshotRemote = nil,
		_balancesByCurrency = {},
		_inventoryItems = {},
		_upgradeLevels = {},
		_unlockedZones = {},
		_questProgress = {},
		_questCompleted = {},
		InteractionResultReceived = Signal.new(),
		TaskCompletedReceived = Signal.new(),
		EconomyUpdatedReceived = Signal.new(),
		InventoryUpdatedReceived = Signal.new(),
		UpgradePurchasedReceived = Signal.new(),
		UpgradePurchaseResultReceived = Signal.new(),
		ZoneUnlockedReceived = Signal.new(),
		ZoneUnlockResultReceived = Signal.new(),
		QuestProgressedReceived = Signal.new(),
		QuestCompletedReceived = Signal.new(),
		SnapshotReceived = Signal.new(),
		CustomerSpawnedReceived = Signal.new(),
		CustomerCompletedReceived = Signal.new(),
		StationChangedReceived = Signal.new(),
	}, FeedbackService)

	return self
end

function FeedbackService:_newRequestId(): string
	return HttpService:GenerateGUID(false)
end

function FeedbackService:Start()
	if self._started then
		return
	end

	self._started = true

	self._performInteractionRemote = Remotes.WaitForEvent(RemoteNames.PerformInteraction)
	self._purchaseUpgradeRemote = Remotes.WaitForEvent(RemoteNames.PurchaseUpgrade)
	self._unlockZoneRemote = Remotes.WaitForEvent(RemoteNames.UnlockZone)
	self._requestSnapshotRemote = Remotes.WaitForEvent(RemoteNames.RequestSnapshot)

	Remotes.WaitForEvent(RemoteNames.InteractionResult).OnClientEvent:Connect(function(payload: any)
		self.InteractionResultReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.UpgradePurchaseResult).OnClientEvent
		:Connect(function(payload: any)
			self.UpgradePurchaseResultReceived:Fire(payload)
		end)

	Remotes.WaitForEvent(RemoteNames.ZoneUnlockResult).OnClientEvent:Connect(function(payload: any)
		self.ZoneUnlockResultReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.TaskCompleted).OnClientEvent:Connect(function(payload: any)
		self.TaskCompletedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.EconomyUpdated).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.currency) == "string" then
			self._balancesByCurrency[payload.currency] = payload.balance or 0
		end
		self.EconomyUpdatedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.InventoryUpdated).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.itemId) == "string" then
			self._inventoryItems[payload.itemId] = payload.newCount or 0
		end
		self.InventoryUpdatedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.UpgradePurchased).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.upgradeId) == "string" then
			self._upgradeLevels[payload.upgradeId] = payload.newLevel or 0
		end
		self.UpgradePurchasedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.ZoneUnlocked).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.zoneId) == "string" then
			self._unlockedZones[payload.zoneId] = true
		end
		self.ZoneUnlockedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.QuestProgressed).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.questId) == "string" then
			local questProgress = self._questProgress[payload.questId]
			if not questProgress then
				questProgress = {}
				self._questProgress[payload.questId] = questProgress
			end

			if type(payload.objectiveId) == "string" then
				questProgress[payload.objectiveId] = payload.progress or 0
			end
		end
		self.QuestProgressedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.QuestCompleted).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" and type(payload.questId) == "string" then
			self._questCompleted[payload.questId] = true
		end
		self.QuestCompletedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.Snapshot).OnClientEvent:Connect(function(payload: any)
		if type(payload) == "table" then
			self._balancesByCurrency = deepClone(payload.currencies or {})
			self._inventoryItems = deepClone(payload.inventory or {})
			self._upgradeLevels = deepClone(payload.upgrades or {})
			self._unlockedZones = deepClone(payload.unlockedZones or {})
			local quests = payload.quests or {}
			self._questProgress = deepClone(quests.progress or {})
			self._questCompleted = deepClone(quests.completed or {})
		end
		self.SnapshotReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.CustomerSpawned).OnClientEvent:Connect(function(payload: any)
		self.CustomerSpawnedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.CustomerCompleted).OnClientEvent:Connect(function(payload: any)
		self.CustomerCompletedReceived:Fire(payload)
	end)

	Remotes.WaitForEvent(RemoteNames.StationChanged).OnClientEvent:Connect(function(payload: any)
		self.StationChangedReceived:Fire(payload)
	end)
end

function FeedbackService:RequestInteraction(interactionId: string): string
	assert(interactionId ~= "", "interactionId is required")
	local remote = self._performInteractionRemote
	assert(remote, "FeedbackService:Start must run before RequestInteraction")

	local requestId = self:_newRequestId()
	remote:FireServer({
		requestId = requestId,
		interactionId = interactionId,
	})
	return requestId
end

function FeedbackService:RequestUpgradePurchase(upgradeId: string): string
	assert(upgradeId ~= "", "upgradeId is required")
	local remote = self._purchaseUpgradeRemote
	assert(remote, "FeedbackService:Start must run before RequestUpgradePurchase")

	local requestId = self:_newRequestId()
	remote:FireServer({
		requestId = requestId,
		upgradeId = upgradeId,
	})
	return requestId
end

function FeedbackService:RequestZoneUnlock(zoneId: string): string
	assert(zoneId ~= "", "zoneId is required")
	local remote = self._unlockZoneRemote
	assert(remote, "FeedbackService:Start must run before RequestZoneUnlock")

	local requestId = self:_newRequestId()
	remote:FireServer({
		requestId = requestId,
		zoneId = zoneId,
	})
	return requestId
end

function FeedbackService:RequestSnapshot()
	local remote = self._requestSnapshotRemote
	assert(remote, "FeedbackService:Start must run before RequestSnapshot")
	remote:FireServer()
end

function FeedbackService:GetBalance(currency: string): number
	return self._balancesByCurrency[currency] or 0
end

function FeedbackService:GetInventoryItems(): { [string]: number }
	return deepClone(self._inventoryItems)
end

function FeedbackService:GetUpgradeLevels(): { [string]: number }
	return deepClone(self._upgradeLevels)
end

function FeedbackService:GetUnlockedZones(): { [string]: boolean }
	return deepClone(self._unlockedZones)
end

function FeedbackService:GetQuestState(): {
	progress: { [string]: { [string]: number } },
	completed: { [string]: boolean },
}
	return {
		progress = deepClone(self._questProgress),
		completed = deepClone(self._questCompleted),
	}
end

return FeedbackService
