# My Brainrot Taxi Demo

This demo is based on the "my brainrot taxi" idea from the root README and consumes the framework as a Wally dependency.

## What This Demo Shows

- package consumption through `lluxy8/brainrot-framework`
- server/client bootstrap from `ReplicatedStorage.Packages["brainrot-framework"]`
- framework interactions wired to in-world `ProximityPrompt` stations
- client HUD updates from framework player attributes (`Brainrot_Coins`, task reward data)

## Folder Layout

```text
demos/brainrot-taxi
|- default.project.json
|- wally.toml
|- src
|  |- ServerScriptService/BrainrotTaxiServer.server.luau
|  `- StarterPlayer/StarterPlayerScripts/BrainrotTaxiClient.client.luau
```

## Run The Demo

1. Open a terminal in `demos/brainrot-taxi`.
2. Install dependency package:
   - `wally install`
3. Start Rojo:
   - `rojo serve default.project.json`
4. In Roblox Studio, connect with Rojo and play.
5. Use the two prompt stations:
   - `Wash Taxi` -> `WashCarInteract`
   - `Drop Passenger` -> `ServeCustomerInteract`

## Implementation Notes

- `default.project.json` mounts framework runtime trees directly from the installed Wally package path:
  - `ReplicatedStorage.BrainrotFramework` -> package `src/Shared`
  - `ServerScriptService.BrainrotFrameworkServer` -> package `src/Server` subfolders (`Bootstrap`, `Components`, `Controllers`, `Services`)
  - `StarterPlayerScripts.BrainrotFrameworkClient` -> package `src/Client` subfolders (`Bootstrap`, `Components`, `Controllers`, `Services`)
- The demo scripts bootstrap via `RegisterServices/RegisterComponents` and `RegisterControllers` directly.
- The client script binds prompt instances to framework interaction IDs through `InteractionPromptComponent`.

## Version Bump Note

- This demo path is pinned to framework version `0.2.0` in both:
  - `wally.toml`
  - `default.project.json` package mount path (`...@0.2.0/...`)
- If you update framework version, update both references.

## Troubleshooting

- If framework instances are missing, run `wally install` again inside `demos/brainrot-taxi` and restart `rojo serve`.
