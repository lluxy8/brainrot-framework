--!strict

local RemoteNames = {
	PerformInteraction = "PerformInteraction",
	InteractionResult = "InteractionResult",
	PurchaseUpgrade = "PurchaseUpgrade",
	UpgradePurchaseResult = "UpgradePurchaseResult",
	UnlockZone = "UnlockZone",
	ZoneUnlockResult = "ZoneUnlockResult",
	RequestSnapshot = "RequestSnapshot",
	Snapshot = "Snapshot",
	TaskCompleted = "TaskCompleted",
	EconomyUpdated = "EconomyUpdated",
	InventoryUpdated = "InventoryUpdated",
	UpgradePurchased = "UpgradePurchased",
	ZoneUnlocked = "ZoneUnlocked",
	QuestProgressed = "QuestProgressed",
	QuestCompleted = "QuestCompleted",
	CustomerSpawned = "CustomerSpawned",
	CustomerCompleted = "CustomerCompleted",
	StationChanged = "StationChanged",
}

export type RemoteName = string

return table.freeze(RemoteNames)
