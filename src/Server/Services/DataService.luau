--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local ProfileTemplate = require(Shared.Data.ProfileTemplate)

type Profile = ProfileTemplate.Profile

local DataService = {}
DataService.__index = DataService

export type DataService = typeof(setmetatable(
	{} :: {
		_profiles: { [number]: Profile },
		_started: boolean,
	},
	DataService
))

function DataService.new(): DataService
	local self = setmetatable({
		_profiles = {},
		_started = false,
	}, DataService)

	return self
end

local function deepClone(value: any): any
	if type(value) ~= "table" then
		return value
	end

	local copy = {}
	for key, nestedValue in pairs(value) do
		copy[deepClone(key)] = deepClone(nestedValue)
	end
	return copy
end

function DataService:_createProfileForPlayer(player: Player): Profile
	local existingProfile = self._profiles[player.UserId]
	if existingProfile then
		return existingProfile
	end

	local profile = ProfileTemplate.Create()
	self._profiles[player.UserId] = profile
	return profile
end

function DataService:Start()
	if self._started then
		return
	end

	self._started = true

	for _, player in Players:GetPlayers() do
		self:_createProfileForPlayer(player)
	end

	Players.PlayerAdded:Connect(function(player)
		self:_createProfileForPlayer(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._profiles[player.UserId] = nil
	end)
end

function DataService:GetProfile(player: Player): Profile?
	return self._profiles[player.UserId]
end

function DataService:GetOrCreateProfile(player: Player): Profile
	local existingProfile = self:GetProfile(player)
	if existingProfile then
		return existingProfile
	end

	return self:_createProfileForPlayer(player)
end

function DataService:GetTaskCompletionCount(player: Player, taskId: string): number
	local profile = self:GetOrCreateProfile(player)
	return profile.tasks.completedCounts[taskId] or 0
end

function DataService:IncrementTaskCompletion(player: Player, taskId: string): number
	local profile = self:GetOrCreateProfile(player)
	local currentValue = profile.tasks.completedCounts[taskId] or 0
	local nextValue = currentValue + 1
	profile.tasks.completedCounts[taskId] = nextValue
	return nextValue
end

function DataService:GetCurrencyBalance(player: Player, currencyCode: string): number
	local profile = self:GetOrCreateProfile(player)
	return profile.economy[currencyCode] or 0
end

function DataService:AddCurrency(player: Player, currencyCode: string, amount: number): number
	local profile = self:GetOrCreateProfile(player)
	local currentBalance = profile.economy[currencyCode] or 0
	local nextBalance = currentBalance + amount
	if nextBalance < 0 then
		nextBalance = 0
	end

	profile.economy[currencyCode] = nextBalance
	return nextBalance
end

function DataService:GetInventoryItems(player: Player): { [string]: number }
	local profile = self:GetOrCreateProfile(player)
	return table.clone(profile.inventory.items)
end

function DataService:GetItemCount(player: Player, itemId: string): number
	local profile = self:GetOrCreateProfile(player)
	return profile.inventory.items[itemId] or 0
end

function DataService:AddInventoryItem(player: Player, itemId: string, amount: number): number
	local profile = self:GetOrCreateProfile(player)
	local currentCount = profile.inventory.items[itemId] or 0
	local nextCount = currentCount + amount
	if nextCount < 0 then
		nextCount = 0
	end

	profile.inventory.items[itemId] = nextCount
	return nextCount
end

function DataService:RemoveInventoryItem(
	player: Player,
	itemId: string,
	amount: number
): (boolean, number)
	local profile = self:GetOrCreateProfile(player)
	local currentCount = profile.inventory.items[itemId] or 0
	if currentCount < amount then
		return false, currentCount
	end

	local nextCount = currentCount - amount
	profile.inventory.items[itemId] = nextCount
	return true, nextCount
end

function DataService:GetUpgradeLevel(player: Player, upgradeId: string): number
	local profile = self:GetOrCreateProfile(player)
	return profile.upgrades.levels[upgradeId] or 0
end

function DataService:SetUpgradeLevel(player: Player, upgradeId: string, level: number): number
	local profile = self:GetOrCreateProfile(player)
	local normalizedLevel = math.max(0, math.floor(level))
	profile.upgrades.levels[upgradeId] = normalizedLevel
	return normalizedLevel
end

function DataService:GetUpgradeLevels(player: Player): { [string]: number }
	local profile = self:GetOrCreateProfile(player)
	return table.clone(profile.upgrades.levels)
end

function DataService:IsZoneUnlocked(player: Player, zoneId: string): boolean
	local profile = self:GetOrCreateProfile(player)
	return profile.zones.unlocked[zoneId] == true
end

function DataService:SetZoneUnlocked(player: Player, zoneId: string, unlocked: boolean)
	local profile = self:GetOrCreateProfile(player)
	profile.zones.unlocked[zoneId] = unlocked
end

function DataService:GetUnlockedZones(player: Player): { [string]: boolean }
	local profile = self:GetOrCreateProfile(player)
	return table.clone(profile.zones.unlocked)
end

function DataService:GetQuestObjectiveProgress(
	player: Player,
	questId: string,
	objectiveId: string
): number
	local profile = self:GetOrCreateProfile(player)
	local questProgress = profile.quests.progress[questId]
	if not questProgress then
		return 0
	end

	return questProgress[objectiveId] or 0
end

function DataService:SetQuestObjectiveProgress(
	player: Player,
	questId: string,
	objectiveId: string,
	progress: number
): number
	local profile = self:GetOrCreateProfile(player)
	local questProgress = profile.quests.progress[questId]
	if not questProgress then
		questProgress = {}
		profile.quests.progress[questId] = questProgress
	end

	local normalized = math.max(0, math.floor(progress))
	questProgress[objectiveId] = normalized
	return normalized
end

function DataService:GetQuestProgress(player: Player, questId: string): { [string]: number }
	local profile = self:GetOrCreateProfile(player)
	local questProgress = profile.quests.progress[questId]
	if not questProgress then
		return {}
	end

	return table.clone(questProgress)
end

function DataService:IsQuestCompleted(player: Player, questId: string): boolean
	local profile = self:GetOrCreateProfile(player)
	return profile.quests.completed[questId] == true
end

function DataService:SetQuestCompleted(player: Player, questId: string, completed: boolean)
	local profile = self:GetOrCreateProfile(player)
	profile.quests.completed[questId] = completed
end

function DataService:GetProfileSnapshot(player: Player): any
	local profile = self:GetOrCreateProfile(player)
	return deepClone(profile)
end

return DataService
