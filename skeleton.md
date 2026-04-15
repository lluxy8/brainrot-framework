```
brainrot-framework/
├── .gitignore
├── .gitattributes
├── README.md
├── wally.toml
├── default.project.json
├── selene.toml
├── stylua.toml
├── aftman.toml
├── scripts/
│   ├── install.ps1
│   ├── install.sh
│   ├── build.ps1
│   ├── build.sh
│   ├── lint.ps1
│   ├── lint.sh
│   ├── serve.ps1
│   └── serve.sh
├── src/
│   ├── Shared/
│   │   ├── Core/
│   │   │   ├── Signal.luau
│   │   │   ├── Maid.luau
│   │   │   ├── Timer.luau
│   │   │   ├── StateMachine.luau
│   │   │   ├── Registry.luau
│   │   │   └── Types.luau
│   │   ├── Config/
│   │   │   ├── EconomyConfig.luau
│   │   │   ├── UpgradeConfig.luau
│   │   │   ├── TaskConfig.luau
│   │   │   └── ZoneConfig.luau
│   │   ├── Constants/
│   │   │   ├── Currency.luau
│   │   │   ├── TaskState.luau
│   │   │   ├── StationState.luau
│   │   │   └── Remotes.luau
│   │   ├── Net/
│   │   │   ├── RemoteNames.luau
│   │   │   └── PacketTypes.luau
│   │   ├── Utils/
│   │   │   ├── TableUtil.luau
│   │   │   ├── NumberUtil.luau
│   │   │   ├── StringUtil.luau
│   │   │   ├── InstanceUtil.luau
│   │   │   └── ValidationUtil.luau
│   │   ├── Gameplay/
│   │   │   ├── Task/
│   │   │   │   ├── TaskDefinition.luau
│   │   │   │   ├── TaskRunner.luau
│   │   │   │   └── TaskResolver.luau
│   │   │   ├── Station/
│   │   │   │   ├── StationDefinition.luau
│   │   │   │   ├── StationStateMachine.luau
│   │   │   │   └── StationResolver.luau
│   │   │   ├── Interaction/
│   │   │   │   ├── InteractionDefinition.luau
│   │   │   │   ├── InteractionTypes.luau
│   │   │   │   └── InteractionValidator.luau
│   │   │   ├── Economy/
│   │   │   │   ├── CurrencyDefinition.luau
│   │   │   │   └── RewardCalculator.luau
│   │   │   ├── Inventory/
│   │   │   │   ├── ItemDefinition.luau
│   │   │   │   └── InventoryTypes.luau
│   │   │   ├── Upgrade/
│   │   │   │   ├── UpgradeDefinition.luau
│   │   │   │   └── UpgradeEffectResolver.luau
│   │   │   ├── Zone/
│   │   │   │   └── ZoneDefinition.luau
│   │   │   ├── Quest/
│   │   │   │   ├── QuestDefinition.luau
│   │   │   │   └── ObjectiveDefinition.luau
│   │   │   └── Customer/
│   │   │       ├── CustomerDefinition.luau
│   │   │       └── SatisfactionRules.luau
│   │   └── Data/
│   │       ├── ProfileTemplate.luau
│   │       ├── ProfileKeys.luau
│   │       └── DataVersion.luau
│   ├── Server/
│   │   ├── Services/
│   │   │   ├── DataService.luau
│   │   │   ├── EconomyService.luau
│   │   │   ├── InventoryService.luau
│   │   │   ├── UpgradeService.luau
│   │   │   ├── TaskService.luau
│   │   │   ├── StationService.luau
│   │   │   ├── InteractionService.luau
│   │   │   ├── ZoneService.luau
│   │   │   ├── QuestService.luau
│   │   │   ├── CustomerService.luau
│   │   │   ├── RewardService.luau
│   │   │   └── SessionService.luau
│   │   ├── Controllers/
│   │   │   ├── PlayerController.luau
│   │   │   ├── RoundController.luau
│   │   │   └── NPCController.luau
│   │   ├── Components/
│   │   │   ├── Stations/
│   │   │   │   ├── WorkstationComponent.luau
│   │   │   │   ├── DeliveryStationComponent.luau
│   │   │   │   └── QueueStationComponent.luau
│   │   │   ├── Zones/
│   │   │   │   ├── RewardZoneComponent.luau
│   │   │   │   ├── UnlockZoneComponent.luau
│   │   │   │   └── WorkZoneComponent.luau
│   │   │   └── NPC/
│   │   │       └── CustomerComponent.luau
│   │   ├── Bootstrap/
│   │   │   ├── RegisterServices.luau
│   │   │   ├── RegisterComponents.luau
│   │   │   └── InitServer.luau
│   │   └── Init.server.luau
│   └── Client/
│       ├── Controllers/
│       │   ├── HUDController.luau
│       │   ├── PromptController.luau
│       │   ├── ProgressBarController.luau
│       │   ├── NotificationController.luau
│       │   ├── ShopController.luau
│       │   └── UpgradeController.luau
│       ├── Components/
│       │   ├── InteractionPromptComponent.luau
│       │   ├── TaskProgressComponent.luau
│       │   ├── FloatingRewardComponent.luau
│       │   └── HighlightComponent.luau
│       ├── Services/
│       │   ├── InputService.luau
│       │   ├── CameraService.luau
│       │   ├── AudioService.luau
│       │   └── FeedbackService.luau
│       ├── Bootstrap/
│       │   ├── RegisterControllers.luau
│       │   └── InitClient.luau
│       └── Init.client.luau
└── test/
    ├── Shared/
    │   ├── RewardCalculator.spec.luau
    │   ├── UpgradeEffectResolver.spec.luau
    │   └── TaskResolver.spec.luau
    └── Server/
        └── EconomyService.spec.luau
```
