# Architecture

## High-Level Structure

- Shared domain + contracts: `src/Shared`
- Server runtime + authoritative simulation: `src/Server`
- Client runtime + UX/input projection: `src/Client`

## Bootstrap Entry Points

- Server: [`Init.server.luau`](../src/Server/Init.server.luau)
  - calls `FrameworkServer.Start()`
- Client: [`Init.client.luau`](../src/Client/Init.client.luau)
  - calls `FrameworkClient.Start()`

## Registry Pattern

The framework uses a lightweight registry (`Shared/Core/Registry`) for runtime service lookup.

- Server registry ownership:
  - [`RegisterServices.luau`](../src/Server/Bootstrap/RegisterServices.luau)
  - [`RegisterComponents.luau`](../src/Server/Bootstrap/RegisterComponents.luau)
- Client registry ownership:
  - [`RegisterControllers.luau`](../src/Client/Bootstrap/RegisterControllers.luau)

## Server Startup Order

Services are created and started in dependency-safe order:

1. `DataService`
2. `EconomyService`
3. `InventoryService`
4. `ZoneService`
5. `StationService`
6. `UpgradeService`
7. `RewardService`
8. `TaskService`
9. `QuestService`
10. `SessionService`
11. `InteractionService`
12. `CustomerService`

Then network wiring is attached, then server-side components/controllers are started.

## Client Startup Order

1. `FeedbackService` (remote subscriptions and local cache)
2. input/camera/audio services
3. controllers
4. components
5. initial snapshot request (`FeedbackService:RequestSnapshot()`)

## Core Gameplay Flow

Interaction completion path:

1. Client sends `PerformInteraction`.
2. Server validates request and calls `InteractionService:PerformInteraction`.
3. Interaction delegates to station/session/task/reward pipeline.
4. Reward updates economy.
5. Quest service receives task completion and advances objectives.
6. Server emits event packets (`TaskCompleted`, `EconomyUpdated`, `QuestProgressed`, etc.).
7. Client `FeedbackService` updates local cache and emits signals for controllers/components.

## Data Ownership Model

- Server is authoritative for profile state (currency, inventory, upgrades, zones, quests).
- Client keeps a cached projection through `Snapshot` + event deltas.
- Client request endpoints are validated server-side.

