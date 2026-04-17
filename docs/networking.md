# Networking

## Remote Contract Source

Remote names are defined in:

- [`RemoteNames.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Net/RemoteNames.luau)

Helper methods for remote folder/event creation:

- [`Remotes.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Constants/Remotes.luau)

Packet type definitions:

- [`PacketTypes.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Net/PacketTypes.luau)

## Request/Response Endpoints

### `PerformInteraction` -> `InteractionResult`

Client request:

```lua
{ requestId: string, interactionId: string }
```

Server response:

```lua
{
  requestId: string,
  ok: boolean,
  interactionId: string,
  error: string?,
  result: { taskId, rewardAmount, balance, timesCompleted }?
}
```

### `PurchaseUpgrade` -> `UpgradePurchaseResult`

Client request:

```lua
{ requestId: string, upgradeId: string }
```

Server response:

```lua
{
  requestId: string,
  ok: boolean,
  upgradeId: string,
  error: string?,
  result: { upgradeId, newLevel, cost, currency, newBalance }?
}
```

### `UnlockZone` -> `ZoneUnlockResult`

Client request:

```lua
{ requestId: string, zoneId: string }
```

Server response:

```lua
{
  requestId: string,
  ok: boolean,
  zoneId: string,
  error: string?,
  result: { zoneId, cost, currency }?
}
```

### `RequestSnapshot` -> `Snapshot`

Client request:
- no payload

Server response:

```lua
{
  currencies: { [currency]: number },
  inventory: { [itemId]: number },
  upgrades: { [upgradeId]: number },
  unlockedZones: { [zoneId]: boolean },
  quests: {
    progress: { [questId]: { [objectiveId]: number } },
    completed: { [questId]: boolean }
  }
}
```

## Event Streams (Server -> Client)

- `TaskCompleted`
- `EconomyUpdated`
- `InventoryUpdated`
- `UpgradePurchased`
- `ZoneUnlocked`
- `QuestProgressed`
- `QuestCompleted`
- `CustomerSpawned`
- `CustomerCompleted`
- `StationChanged`

## Validation Rules

Server enforces:

- payload must be table for request remotes
- required ids must be non-empty strings
- domain-level checks performed in services
  - interaction validity/cooldown
  - upgrade max-level and affordability
  - zone prerequisites and affordability

On failure, the corresponding `*Result` packet sets:

- `ok = false`
- `error = "<message>"`
- `result = nil`

## Where It Is Wired

Network behavior is defined centrally in:

- [`RegisterServices.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Server/Bootstrap/RegisterServices.luau)

