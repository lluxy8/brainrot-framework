# Brainrot Framework

A modular Roblox game framework designed for rapidly building and scaling "brainrot-style" simulation games.

This framework focuses on reusable gameplay systems such as tasks, interactions, economy, and upgrades, allowing you to produce multiple games with shared logic and minimal duplication.

---

## âœ¨ Features

- Task-based gameplay system
- Interaction system (click, hold, proximity)
- Economy & currency management
- Upgrade system with multipliers
- Basic inventory support
- Data persistence layer
- Modular service architecture
- Client-side UI controllers (progress, prompts, notifications)

---

## ğŸ§  Philosophy

This framework is not meant to define your game.

Instead, it provides a **core backbone** that allows you to:

- build faster
- reuse systems
- maintain consistency across multiple games

Each game should extend the framework, not fight it.

---

## ğŸ“¦ Tech Stack

- Luau
- Rojo
- Wally
- Selene (linting)
- StyLua (formatting)
- Aftman (toolchain)

---

## ğŸš€ Getting Started

### 1. Install tools

Add this to your repo as `wally.toml`

```
[package]
name = "yourname/my-brainrot-taxi"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
brainrot-framework = "muratcan/brainrot-framework@0.2.0"
```

After that call `aftman install`

### 2. Write rojo config

```json
{
  "name": "brainrot-template",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$path": "src/ReplicatedStorage"
    },
    "ServerScriptService": {
      "$path": "src/ServerScriptService"
    },
    "StarterPlayer": {
      "StarterPlayerScripts": {
        "$path": "src/StarterPlayer/StarterPlayerScripts"
      }
    },
    "Workspace": {
      "$path": "src/Workspace"
    }
  }
}
```

## ğŸ’¡ SOME GAME IDEAS TO BUILD WITH THE FRAMEWORK

- my brainrot taxi
- my brainrot carwasher
- my brainrot barber
- my brainrot kingdom
- my brainrot kebab chefs
- my brainrot school
- my brainrot caffee
- my brainrot farm
- brainrot esports
- work at aldi as a brainrot

---

## Local Setup Scripts

The repo now includes setup/build/lint/format/serve scripts based on this README and `skeleton.md`.

### Windows (PowerShell)

```powershell
./scripts/install.ps1
./scripts/lint.ps1
./scripts/format.ps1
./scripts/build.ps1
./scripts/serve.ps1
```

### macOS/Linux (bash)

```bash
./scripts/install.sh
./scripts/lint.sh
./scripts/format.sh
./scripts/build.sh
./scripts/serve.sh
```

---

## Reuse In Another Project

Use semantic versions from Wally in your game project:

```toml
[dependencies]
brainrot-framework = "muratcan/brainrot-framework@0.2.0"
```

Server bootstrap example:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FrameworkServer = require(ReplicatedStorage.Packages["brainrot-framework"].Server.FrameworkServer)

local runtime = FrameworkServer.Start()
local services = runtime.services
```

Client bootstrap example:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FrameworkClient = require(ReplicatedStorage.Packages["brainrot-framework"].Client.FrameworkClient)

local registry = FrameworkClient.Start()
local promptController = registry:Resolve("PromptController")
promptController:TriggerInteraction("WashCarInteract")
```

Shared API example:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage.Packages["brainrot-framework"].Shared.Framework)

print(Framework.GetVersion()) -- 0.2.0
```

---

## Full Documentation

Detailed docs live under [`docs/`](./docs/README.md):

- setup and integration
- architecture and lifecycle
- server/client API references
- networking protocol
- extension and release workflow

