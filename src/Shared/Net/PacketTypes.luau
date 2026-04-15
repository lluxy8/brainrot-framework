--!strict

export type PerformInteractionRequest = {
	requestId: string,
	interactionId: string,
}

export type PurchaseUpgradeRequest = {
	requestId: string,
	upgradeId: string,
}

export type UnlockZoneRequest = {
	requestId: string,
	zoneId: string,
}

export type SessionTaskResult = {
	taskId: string,
	rewardAmount: number,
	balance: number,
	timesCompleted: number,
}

export type InteractionResultPacket = {
	requestId: string,
	ok: boolean,
	interactionId: string,
	error: string?,
	result: SessionTaskResult?,
}

export type UpgradePurchaseResultPacket = {
	requestId: string,
	ok: boolean,
	upgradeId: string,
	error: string?,
	result: {
		upgradeId: string,
		newLevel: number,
		cost: number,
		currency: string,
		newBalance: number,
	}?,
}

export type ZoneUnlockResultPacket = {
	requestId: string,
	ok: boolean,
	zoneId: string,
	error: string?,
	result: {
		zoneId: string,
		cost: number,
		currency: string,
	}?,
}

export type EconomyUpdatedPacket = {
	currency: string,
	delta: number,
	balance: number,
	reason: string,
}

export type TaskCompletedPacket = {
	taskId: string,
	rewardAmount: number,
	balance: number,
	timesCompleted: number,
}

export type QuestProgressedPacket = {
	questId: string,
	objectiveId: string,
	progress: number,
	requiredCount: number,
}

export type QuestCompletedPacket = {
	questId: string,
}

export type InventoryUpdatedPacket = {
	itemId: string,
	delta: number,
	newCount: number,
}

export type UpgradePurchasedPacket = {
	upgradeId: string,
	newLevel: number,
	cost: number,
	currency: string,
	newBalance: number,
}

export type ZoneUnlockedPacket = {
	zoneId: string,
	cost: number,
	currency: string,
}

export type CustomerSpawnedPacket = {
	id: string,
	customerTypeId: string,
	displayName: string,
	zoneId: string,
}

export type CustomerCompletedPacket = {
	customerId: string,
	score: number,
	tier: string,
	waitSeconds: number,
	mistakes: number,
}

export type StationChangedPacket = {
	stationId: string,
	state: string,
	playerUserId: number?,
}

export type SnapshotPacket = {
	currencies: { [string]: number },
	inventory: { [string]: number },
	upgrades: { [string]: number },
	unlockedZones: { [string]: boolean },
	quests: {
		progress: { [string]: { [string]: number } },
		completed: { [string]: boolean },
	},
}

local PacketTypes = {}

return PacketTypes
