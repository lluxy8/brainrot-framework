# Getting Started

## Prerequisites

- Roblox Studio
- Aftman
- Rojo
- Wally
- Selene
- StyLua

The repository already includes `aftman.toml`, `default.project.json`, lint/format config, and helper scripts.

## Local Development

### Windows PowerShell

```powershell
./scripts/install.ps1
./scripts/lint.ps1
./scripts/format.ps1
./scripts/build.ps1
./scripts/serve.ps1
```

### macOS/Linux

```bash
./scripts/install.sh
./scripts/lint.sh
./scripts/format.sh
./scripts/build.sh
./scripts/serve.sh
```

## Runtime Mount Points

From [`default.project.json`](/C:/Users/Murat%20Can/Projeler/RobloxBrainrotEngine/default.project.json):

- `ReplicatedStorage.BrainrotFramework` -> `src/Shared`
- `ServerScriptService.BrainrotFrameworkServer` -> `src/Server`
- `StarterPlayer.StarterPlayerScripts.BrainrotFrameworkClient` -> `src/Client`

## Using This Framework In Another Project

Add dependency in the consuming game's `wally.toml`:

```toml
[dependencies]
brainrot-framework = "lluxy8/brainrot-framework@0.2.0"
```

Run:

```bash
wally install
```

Then use package modules from `ReplicatedStorage.Packages["brainrot-framework"]`.

### Server Bootstrap

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FrameworkServer = require(ReplicatedStorage.Packages["brainrot-framework"].Server.FrameworkServer)

local runtime = FrameworkServer.Start()
local services = runtime.services
```

### Client Bootstrap

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FrameworkClient = require(ReplicatedStorage.Packages["brainrot-framework"].Client.FrameworkClient)

local registry = FrameworkClient.Start()
```

### Shared API Access

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage.Packages["brainrot-framework"].Shared.Framework)

print(Framework.GetVersion()) -- 0.2.0
```

## Quick Smoke Test

1. Start server and client bootstraps.
2. Trigger an interaction from client:
   - `PromptController:TriggerInteraction("WashCarInteract")`
3. Verify:
   - `TaskCompleted` and `EconomyUpdated` events arrive in `FeedbackService`.
   - player attributes update (`Brainrot_Coins`, task/progress attributes).
