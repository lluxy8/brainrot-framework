# Server Reference

## Runtime Surface

Primary server API entry:

- [`FrameworkServer.luau`](../src/Server/FrameworkServer.luau)
  - `Start() -> { services, components }`
  - `GetRuntime()`
  - `GetServiceRegistry()`
  - `GetComponentRegistry()`

## Services

### DataService

File: [`DataService.luau`](../src/Server/Services/DataService.luau)

Purpose:
- in-memory profile lifecycle and state primitives

Key methods:
- `GetOrCreateProfile(player)`
- `GetCurrencyBalance/AddCurrency`
- `GetItemCount/AddInventoryItem/RemoveInventoryItem`
- `GetUpgradeLevel/SetUpgradeLevel`
- `IsZoneUnlocked/SetZoneUnlocked`
- quest progress/completion helpers
- `GetProfileSnapshot(player)`

### EconomyService

File: [`EconomyService.luau`](../src/Server/Services/EconomyService.luau)

Purpose:
- currency mutation rules and spending checks

Key methods:
- `GetBalance`
- `AddCurrency`
- `SpendCurrency`

### InventoryService

File: [`InventoryService.luau`](../src/Server/Services/InventoryService.luau)

Signal:
- `ItemChanged`

Key methods:
- `GetItems`
- `GetItemCount`
- `HasItem`
- `AddItem`
- `RemoveItem`

### ZoneService

File: [`ZoneService.luau`](../src/Server/Services/ZoneService.luau)

Signal:
- `ZoneUnlocked`

Key methods:
- `IsUnlocked`
- `GetUnlockedZones`
- `UnlockZone`

### StationService

File: [`StationService.luau`](../src/Server/Services/StationService.luau)

Signal:
- `StationChanged`

Key methods:
- `TryGetStation`
- `ReserveStation`
- `BeginUse`
- `ReleaseStation`

### UpgradeService

File: [`UpgradeService.luau`](../src/Server/Services/UpgradeService.luau)

Signal:
- `UpgradePurchased`

Key methods:
- `GetDefinitions`
- `GetUpgradeLevel`
- `GetUpgradeCost`
- `PurchaseUpgrade`
- `GetTaskRewardMultiplier`

### RewardService

File: [`RewardService.luau`](../src/Server/Services/RewardService.luau)

Purpose:
- computes and applies rewards from task completion

Key methods:
- `SetUpgradeService`
- `GrantTaskReward`

### TaskService

File: [`TaskService.luau`](../src/Server/Services/TaskService.luau)

Signal:
- `TaskCompleted`

Key methods:
- `CompleteTask`
- `GetTaskCompletionCount`

### QuestService

File: [`QuestService.luau`](../src/Server/Services/QuestService.luau)

Signals:
- `QuestProgressed`
- `QuestCompleted`

Key methods:
- `GetQuestProgress`
- `IsQuestCompleted`
- `GetAllQuests`

### SessionService

File: [`SessionService.luau`](../src/Server/Services/SessionService.luau)

Purpose:
- higher-level task completion endpoint for gameplay integrations

Key method:
- `CompleteTaskForPlayer(player, taskId)`

### InteractionService

File: [`InteractionService.luau`](../src/Server/Services/InteractionService.luau)

Signal:
- `InteractionPerformed`

Key method:
- `PerformInteraction(player, interactionId)`

### CustomerService

File: [`CustomerService.luau`](../src/Server/Services/CustomerService.luau)

Signals:
- `CustomerSpawned`
- `CustomerCompleted`
- `CustomerRemoved`

Key methods:
- `SpawnCustomer`
- `GetCustomer`
- `GetActiveCustomers`
- `CompleteCustomer`
- `RemoveCustomer`

## Server Controllers

### PlayerController

File: [`PlayerController.luau`](../src/Server/Controllers/PlayerController.luau)

Responsibilities:
- sync profile/economy/zone counts into player attributes

### NPCController

File: [`NPCController.luau`](../src/Server/Controllers/NPCController.luau)

Responsibilities:
- track active customer count from service signals

### RoundController

File: [`RoundController.luau`](../src/Server/Controllers/RoundController.luau)

Responsibilities:
- timed customer spawning loop (default wave behavior)

## Server Components

Station components:
- [`WorkstationComponent.luau`](../src/Server/Components/Stations/WorkstationComponent.luau)
- [`DeliveryStationComponent.luau`](../src/Server/Components/Stations/DeliveryStationComponent.luau)
- [`QueueStationComponent.luau`](../src/Server/Components/Stations/QueueStationComponent.luau)

Zone components:
- [`RewardZoneComponent.luau`](../src/Server/Components/Zones/RewardZoneComponent.luau)
- [`UnlockZoneComponent.luau`](../src/Server/Components/Zones/UnlockZoneComponent.luau)
- [`WorkZoneComponent.luau`](../src/Server/Components/Zones/WorkZoneComponent.luau)

NPC component:
- [`CustomerComponent.luau`](../src/Server/Components/NPC/CustomerComponent.luau)

