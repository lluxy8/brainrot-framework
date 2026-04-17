# Client Reference

## Runtime Surface

Primary client API entry:

- [`FrameworkClient.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/FrameworkClient.luau)
  - `Start() -> Registry`
  - `GetRegistry()`

## Core Client Service

### FeedbackService

File: [`FeedbackService.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Services/FeedbackService.luau)

Purpose:
- owns RemoteEvent subscriptions
- sends client requests
- keeps local state cache from `Snapshot` + incremental events

Request methods:
- `RequestInteraction(interactionId)`
- `RequestUpgradePurchase(upgradeId)`
- `RequestZoneUnlock(zoneId)`
- `RequestSnapshot()`

Read methods:
- `GetBalance(currency)`
- `GetInventoryItems()`
- `GetUpgradeLevels()`
- `GetUnlockedZones()`
- `GetQuestState()`

Signals exposed:
- `InteractionResultReceived`
- `TaskCompletedReceived`
- `EconomyUpdatedReceived`
- `InventoryUpdatedReceived`
- `UpgradePurchasedReceived`
- `UpgradePurchaseResultReceived`
- `ZoneUnlockedReceived`
- `ZoneUnlockResultReceived`
- `QuestProgressedReceived`
- `QuestCompletedReceived`
- `SnapshotReceived`
- `CustomerSpawnedReceived`
- `CustomerCompletedReceived`
- `StationChangedReceived`

## Supporting Client Services

- [`InputService.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Services/InputService.luau)
  - emits `InteractionPressed` for keyboard/gamepad input
- [`CameraService.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Services/CameraService.luau)
  - camera tween focus helper
- [`AudioService.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Services/AudioService.luau)
  - one-shot 2D audio helper

## Controllers

- [`PromptController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Controllers/PromptController.luau)
  - interaction dispatch and active prompt targeting
- [`HUDController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Controllers/HUDController.luau)
  - player attribute projection (`coins`, `task`, `zone counts`)
- [`NotificationController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Controllers/NotificationController.luau)
  - warning/print channel for failures and quest completion
- [`ProgressBarController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Controllers/ProgressBarController.luau)
  - task and quest progress projection to attributes
- [`ShopController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Controllers/ShopController.luau)
  - zone unlock requests
- [`UpgradeController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Controllers/UpgradeController.luau)
  - upgrade purchase requests and local level access

## Components

- [`InteractionPromptComponent.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Components/InteractionPromptComponent.luau)
  - bind `ProximityPrompt` to a framework interaction id
- [`TaskProgressComponent.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Components/TaskProgressComponent.luau)
  - local task completion tracker
- [`FloatingRewardComponent.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Components/FloatingRewardComponent.luau)
  - reward/balance attributes + reward sound
- [`HighlightComponent.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Components/HighlightComponent.luau)
  - helper for target highlight display

## Typical Client Usage

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FrameworkClient = require(ReplicatedStorage.Packages["brainrot-framework"].Client.FrameworkClient)

local registry = FrameworkClient.Start()

local promptController = registry:Resolve("PromptController")
local upgradeController = registry:Resolve("UpgradeController")

promptController:TriggerInteraction("WashCarInteract")
upgradeController:Purchase("SpeedGloves")
```

