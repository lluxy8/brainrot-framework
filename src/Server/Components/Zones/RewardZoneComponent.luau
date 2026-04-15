--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("BrainrotFramework") :: any
local Currency = require(Shared.Constants.Currency)

local RewardZoneComponent = {}
RewardZoneComponent.__index = RewardZoneComponent

export type RewardZoneComponent = typeof(setmetatable(
	{} :: {
		_economyService: any,
		_rewardAmount: number,
		_cooldownSeconds: number,
		_lastRewardByUserId: { [number]: number },
	},
	RewardZoneComponent
))

function RewardZoneComponent.new(
	economyService: any,
	rewardAmount: number?,
	cooldownSeconds: number?
): RewardZoneComponent
	local self = setmetatable({
		_economyService = economyService,
		_rewardAmount = rewardAmount or 25,
		_cooldownSeconds = cooldownSeconds or 5,
		_lastRewardByUserId = {},
	}, RewardZoneComponent)

	return self
end

function RewardZoneComponent:Start()
	-- Intentionally empty.
end

function RewardZoneComponent:Claim(player: Player): (boolean, string?, number)
	local now = os.clock()
	local lastRewardAt = self._lastRewardByUserId[player.UserId] or 0
	local elapsed = now - lastRewardAt
	if elapsed < self._cooldownSeconds then
		return false, string.format("Reward cooldown: %.2fs", self._cooldownSeconds - elapsed), 0
	end

	self._lastRewardByUserId[player.UserId] = now
	local balance =
		self._economyService:AddCurrency(player, Currency.Coins, self._rewardAmount, "RewardZone")
	return true, nil, balance
end

return RewardZoneComponent
