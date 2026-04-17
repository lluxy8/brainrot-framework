# Config Reference

## Purpose

Config files in `src/Shared/Config` define default gameplay shape and are intended to be edited by game teams.

## Task Config

File: [`TaskConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/TaskConfig.luau)

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

File: [`UpgradeConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/UpgradeConfig.luau)

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

File: [`ZoneConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/ZoneConfig.luau)

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

File: [`EconomyConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/EconomyConfig.luau)

Fields:

- `TaskRewardMultiplier`
- `RepeatCompletionBonus`
- `StartingBalances`

## Asset Config

File: [`AssetConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/AssetConfig.luau)

Fields:

- `Sounds.TaskReward`

## Related Shared Definitions

- Tasks: [`TaskDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Task/TaskDefinition.luau)
- Upgrades: [`UpgradeDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Upgrade/UpgradeDefinition.luau)
- Zones: [`ZoneDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Zone/ZoneDefinition.luau)
- Interactions: [`InteractionDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Interaction/InteractionDefinition.luau)
- Stations: [`StationDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Station/StationDefinition.luau)
- Quests: [`QuestDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Quest/QuestDefinition.luau)
