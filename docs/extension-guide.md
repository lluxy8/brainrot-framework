# Extension Guide

## Add A New Task

1. Add definition in [`TaskConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/TaskConfig.luau).
2. Add interaction mapping in [`InteractionDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Interaction/InteractionDefinition.luau).
3. If station-bound, add/update station in [`StationDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Station/StationDefinition.luau).
4. Optionally add quest objective in [`QuestDefinition.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Quest/QuestDefinition.luau).

No network changes are required if you continue using `PerformInteraction`.

## Add A New Upgrade

1. Add config entry in [`UpgradeConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/UpgradeConfig.luau).
2. If it should affect rewards, update logic in [`UpgradeEffectResolver.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Gameplay/Upgrade/UpgradeEffectResolver.luau).
3. Use client `UpgradeController:Purchase("<UpgradeId>")`.

## Add A New Zone

1. Add zone in [`ZoneConfig.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Config/ZoneConfig.luau).
2. Attach stations/interactions to that zone.
3. Use `ShopController:RequestZoneUnlock("<ZoneId>")` client-side.

## Add A New Remote Endpoint

1. Add name in [`RemoteNames.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Net/RemoteNames.luau).
2. Add payload type in [`PacketTypes.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Shared/Net/PacketTypes.luau).
3. Wire server handler in [`RegisterServices.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Server/Bootstrap/RegisterServices.luau).
4. Subscribe/request in [`FeedbackService.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Client/Services/FeedbackService.luau).
5. Expose through controller/component if needed.

## Override Default Gameplay Loops

- Customer wave logic lives in [`RoundController.luau`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/src/Server/Controllers/RoundController.luau).
- You can fork or replace with your own strategy while keeping existing services.

## Recommended Team Workflow

1. Edit shared config + definition modules first.
2. Add/adjust service behavior.
3. Wire client requests and signal listeners.
4. Run:
   - `./scripts/format.ps1`
   - `./scripts/lint.ps1`
   - `./scripts/build.ps1`
5. Document behavior change in `docs/`.

