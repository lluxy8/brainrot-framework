# Config Reference

## Purpose

Config files in `src/Shared/Config` define default gameplay shape and are intended to be edited by game teams.

## Task Config

File: [`TaskConfig.luau`](../src/Shared/Config/TaskConfig.luau)

Current tasks:

- `WashCar`
- `ServeCustomer`

Definition fields:

- `id`
- `displayName`
- `currency`
- `baseReward`
- `requiredProgress`

## Upgrade Config

File: [`UpgradeConfig.luau`](../src/Shared/Config/UpgradeConfig.luau)

Current upgrades:

- `SpeedGloves`
- `TipJar`

Definition fields:

- `id`
- `displayName`
- `currency`
- `baseCost`
- `costScale`
- `maxLevel`
- `taskRewardMultiplierPerLevel`

## Zone Config

File: [`ZoneConfig.luau`](../src/Shared/Config/ZoneConfig.luau)

Current zones:

- `StarterZone`
- `MarketZone`

Definition fields:

- `id`
- `displayName`
- `currency`
- `unlockCost`
- `prerequisiteZoneId`
- `unlockedByDefault`

## Economy Config

File: [`EconomyConfig.luau`](../src/Shared/Config/EconomyConfig.luau)

Fields:

- `TaskRewardMultiplier`
- `RepeatCompletionBonus`
- `StartingBalances`

## Asset Config

File: [`AssetConfig.luau`](../src/Shared/Config/AssetConfig.luau)

Fields:

- `Sounds.TaskReward`
- `Decals.GuideArrow`

## Related Shared Definitions

- Tasks: [`TaskDefinition.luau`](../src/Shared/Gameplay/Task/TaskDefinition.luau)
- Upgrades: [`UpgradeDefinition.luau`](../src/Shared/Gameplay/Upgrade/UpgradeDefinition.luau)
- Zones: [`ZoneDefinition.luau`](../src/Shared/Gameplay/Zone/ZoneDefinition.luau)
- Interactions: [`InteractionDefinition.luau`](../src/Shared/Gameplay/Interaction/InteractionDefinition.luau)
- Stations: [`StationDefinition.luau`](../src/Shared/Gameplay/Station/StationDefinition.luau)
- Quests: [`QuestDefinition.luau`](../src/Shared/Gameplay/Quest/QuestDefinition.luau)
