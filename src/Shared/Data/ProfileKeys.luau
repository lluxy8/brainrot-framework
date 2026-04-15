--!strict

local ProfileKeys = {
	Version = "version",
	Economy = "economy",
	Tasks = "tasks",
	CompletedCounts = "completedCounts",
	Inventory = "inventory",
	Items = "items",
	Upgrades = "upgrades",
	Levels = "levels",
	Zones = "zones",
	Unlocked = "unlocked",
	Quests = "quests",
	Progress = "progress",
	QuestCompleted = "completed",
}

return table.freeze(ProfileKeys)
