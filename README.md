# Brainrot Framework

A modular Roblox game framework designed for rapidly building and scaling "brainrot-style" simulation games.

This framework focuses on reusable gameplay systems such as tasks, interactions, economy, and upgrades, allowing you to produce multiple games with shared logic and minimal duplication.

---

## ✨ Features

- Task-based gameplay system
- Interaction system (click, hold, proximity)
- Economy & currency management
- Upgrade system with multipliers
- Basic inventory support
- Data persistence layer
- Modular service architecture
- Client-side UI controllers (progress, prompts, notifications)

---

## 🧠 Philosophy

This framework is not meant to define your game.

Instead, it provides a **core backbone** that allows you to:

- build faster
- reuse systems
- maintain consistency across multiple games

Each game should extend the framework, not fight it.

---

## 📦 Tech Stack

- Luau
- Rojo
- Wally
- Selene (linting)
- StyLua (formatting)
- Aftman (toolchain)

---

## 🚀 Getting Started

### 1. Install tools

Add this to your repo as `wally.toml`

```
[package]
name = "seninadın/my-brainrot-taxi"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
brainrot-framework = "seninadın/brainrot-framework@0.1.0"
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

## 💡 SOME GAME IDEAS TO BUILD WITH THE FRAMEWORK

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
