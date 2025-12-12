# JJK Roblox System - Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ROBLOX STUDIO                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                 REPLICATED STORAGE                           │   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │                                                              │   │
│  │  ┌─────────────┐  ┌──────────────────────────────────┐     │   │
│  │  │ JJKShared   │  │    JJKRemotes (Created at       │     │   │
│  │  │ (Folder)    │  │    runtime by server)           │     │   │
│  │  ├─────────────┤  ├──────────────────────────────────┤     │   │
│  │  │ Config      │  │ SelectCharacter (RemoteEvent)   │     │   │
│  │  │ CharacterD. │  │ UseAbility (RemoteEvent)        │     │   │
│  │  │ AbilityData │  │ GetPlayerData (RemoteFunction)  │     │   │
│  │  └─────────────┘  │ GetAbilityInfo (RemoteFunction) │     │   │
│  │                   │ AbilityEffect (RemoteEvent)     │     │   │
│  │                   └──────────────────────────────────┘     │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │             SERVER SCRIPT SERVICE                            │   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │  PlayerData.server.lua (217 lines)                 │   │   │
│  │  │  • Player initialization & management               │   │   │
│  │  │  • Whitelist & admin validation                     │   │   │
│  │  │  • CE regeneration system                           │   │   │
│  │  │  • Cooldown tracking                                │   │   │
│  │  │  • Character selection handling                     │   │   │
│  │  │  • RemoteEvent setup                                │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │  AbilityHandler.server.lua (115 lines)             │   │   │
│  │  │  • Ability execution                                │   │   │
│  │  │  • Damage dealing logic                             │   │   │
│  │  │  • AOE calculations                                 │   │   │
│  │  │  • Effect handling (Attack, Defense, etc.)          │   │   │
│  │  │  • Visual effect replication                        │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │      STARTER PLAYER > STARTER PLAYER SCRIPTS                 │   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │  CharacterSelectGUI.client.lua (178 lines)         │   │   │
│  │  │  • Creates character selection menu                 │   │   │
│  │  │  • Top-left 250×400 scrollable GUI                  │   │   │
│  │  │  • Regular Characters section                       │   │   │
│  │  │  • Admin Characters section (admin only)            │   │   │
│  │  │  • Button creation & event handling                 │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │  AbilityInfoPanel.client.lua (303 lines)           │   │   │
│  │  │  • Creates ability info panel (K key)               │   │   │
│  │  │  • Left-side 300×500 sliding panel                  │   │   │
│  │  │  • CE bar with visual fill                          │   │   │
│  │  │  • Scrollable ability cards                         │   │   │
│  │  │  • Real-time updates (1s interval)                  │   │   │
│  │  │  • Shows: Name, Type, Damage, CE, Cooldown          │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  │                                                              │   │
│  │  ┌─────────────────────────────────────────────────────┐   │   │
│  │  │  InputHandler.client.lua (51 lines)                │   │   │
│  │  │  • Keyboard input handling                          │   │   │
│  │  │  • Number keys 1-5 (regular) / 1-0 (admin)          │   │   │
│  │  │  • Sends ability usage to server                    │   │   │
│  │  └─────────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Flow

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│              │         │              │         │              │
│   CLIENT     │◄───────►│   SHARED     │◄───────►│   SERVER     │
│  (LocalScript)         │  (Modules)   │         │  (Script)    │
│              │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
       │                        │                        │
       │                        │                        │
       ▼                        ▼                        ▼
┌─────────────┐         ┌──────────────┐        ┌──────────────┐
│ GUI Display │         │ Config.lua   │        │ Player Data  │
│ Input Handle│         │ CharacterData│        │ Validation   │
│ Animations  │         │ AbilityData  │        │ CE Management│
└─────────────┘         └──────────────┘        │ Cooldowns    │
                                                 └──────────────┘
```

## Communication Flow

```
1. Player Joins
   └─► Server: Initialize player data
       └─► Client: Show GUI (if whitelisted)

2. Character Selection
   └─► Client: Click character button
       └─► Server: SelectCharacter RemoteEvent
           └─► Server: Update player data
               └─► Client: Visual feedback

3. Open Ability Panel (K key)
   └─► Client: Toggle panel visibility
       └─► Server: GetPlayerData RemoteFunction
           └─► Client: Display abilities & CE bar
               └─► Client: Update every 1 second

4. Use Ability (1-5 or 1-0 keys)
   └─► Client: Detect key press
       └─► Server: UseAbility RemoteEvent
           └─► Server: Validate (CE, cooldown, whitelist)
               └─► Server: Execute ability
                   └─► All Clients: AbilityEffect (visual)
                       └─► Server: Update CE & cooldowns

5. CE Regeneration (Background)
   └─► Server: Loop every 1 second
       └─► Server: Check regen delay
           └─► Server: Add CE if conditions met

6. Cooldown Updates (Background)
   └─► Server: Loop every 1 second
       └─► Server: Check cooldown timers
           └─► Server: Remove expired cooldowns
```

## Character System

```
┌─────────────────────────────────────────────────────────────┐
│                     CHARACTER HIERARCHY                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────┐                 ┌──────────────────┐ │
│  │ Regular Chars    │                 │  Admin Chars     │ │
│  │ (5 characters)   │                 │  (5 characters)  │ │
│  ├──────────────────┤                 ├──────────────────┤ │
│  │ • Gojo           │                 │ • Gojo (Admin)   │ │
│  │ • Sukuna         │                 │ • Sukuna (Admin) │ │
│  │ • Megumi         │                 │ • Megumi (Admin) │ │
│  │ • Yuji           │                 │ • Yuji (Admin)   │ │
│  │ • Todo           │                 │ • Todo (Admin)   │ │
│  │                  │                 │                  │ │
│  │ 5 abilities each │                 │ 10 abilities each│ │
│  │ CE costs: 10-100 │                 │ CE costs: 0      │ │
│  │ Cooldowns: 2-50s │                 │ Cooldowns: 0     │ │
│  │ Damage: 0-200    │                 │ Damage: 0-600    │ │
│  │                  │                 │                  │ │
│  │ Types:           │                 │ Types:           │ │
│  │ • Attack (3)     │                 │ • Attack         │ │
│  │ • Defense (1)    │                 │ • Defense        │ │
│  │ • Ultimate (1)   │                 │ • Ultimate       │ │
│  │                  │                 │ • Buff           │ │
│  │                  │                 │ • Mobility       │ │
│  │                  │                 │ • CC             │ │
│  │                  │                 │ • Domain         │ │
│  └──────────────────┘                 └──────────────────┘ │
│                                                              │
│  Total: 25 abilities                  Total: 50 abilities   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## GUI Layout

```
┌─────────────────────────────────────────────────────────────┐
│ Screen (Full viewport)                                       │
│                                                              │
│  ┌───────────┐                                              │
│  │ Character │                                              │
│  │ Selection │                                              │
│  │  Menu     │                                              │
│  │ 250×400px │                                              │
│  ├───────────┤                                              │
│  │ JJK       │                                              │
│  │ Characters│                                              │
│  ├───────────┤                                              │
│  │ Regular   │         ┌─────────────────┐                 │
│  │ Characters│         │  Ability Panel  │                 │
│  ├───────────┤         │  300×500px      │                 │
│  │ • Gojo    │         │  (Press K)      │                 │
│  │ • Sukuna  │         ├─────────────────┤                 │
│  │ • Megumi  │         │ Character: Gojo │                 │
│  │ • Yuji    │         ├─────────────────┤                 │
│  │ • Todo    │         │ CE: ▓▓▓▓░░ 300  │                 │
│  ├───────────┤         ├─────────────────┤                 │
│  │ Admin     │         │ ┌─────────────┐ │                 │
│  │ Characters│         │ │ Blue (Pull) │ │                 │
│  ├───────────┤         │ │ Attack      │ │                 │
│  │ • Gojo    │         │ │ DMG: 25     │ │                 │
│  │   (Admin) │         │ │ CE: 20      │ │                 │
│  │ • Sukuna  │         │ │ CD: 4s      │ │                 │
│  │   (Admin) │         │ └─────────────┘ │                 │
│  │ • ...     │         │ ┌─────────────┐ │                 │
│  └───────────┘         │ │ More        │ │                 │
│  Top-Left              │ │ abilities.. │ │                 │
│  (10, 10)              │ └─────────────┘ │                 │
│                        └─────────────────┘                 │
│                        Left Side                            │
│                        (Slides in/out)                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## File Dependencies

```
Config.lua
  ↓
  ├─► CharacterData.lua
  │     ↓
  │     └─► AbilityData.lua
  │           ↓
  │           ├─► PlayerData.server.lua
  │           │     ↓
  │           │     └─► AbilityHandler.server.lua
  │           │
  │           ├─► CharacterSelectGUI.client.lua
  │           │
  │           ├─► AbilityInfoPanel.client.lua
  │           │
  │           └─► InputHandler.client.lua
```

## Project Statistics

```
┌────────────────────────────────────────────────────────┐
│ Category            │ Count    │ Details               │
├────────────────────────────────────────────────────────┤
│ Total Files         │ 14       │ 8 code + 6 docs       │
│ Lua Scripts         │ 8        │ Server + Client       │
│ Documentation       │ 6        │ MD files              │
│ Total Lines         │ ~2,342   │ Code + docs           │
│ Code Lines          │ ~1,205   │ Lua only              │
│ Characters          │ 10       │ 5 regular + 5 admin   │
│ Abilities           │ 75       │ 25 regular + 50 admin │
│ Ability Types       │ 7        │ Attack to Domain      │
│ RemoteEvents        │ 5        │ Client↔Server comm    │
│ Modules             │ 3        │ Shared data           │
└────────────────────────────────────────────────────────┘
```

## Tech Stack

```
┌─────────────────────────────────────────┐
│ Language:     Lua/Luau                  │
│ Platform:     Roblox                    │
│ Architecture: Client-Server             │
│ GUI:          Roblox UI Library         │
│ Communication: RemoteEvents/Functions   │
│ Storage:      Server-side data store    │
│ Updates:      Task scheduler            │
│ Version:      Modern Luau (2024)        │
└─────────────────────────────────────────┘
```

## Security Model

```
┌─────────────────────────────────────────────────────┐
│                  Security Layers                     │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Layer 1: Whitelist Check                           │
│  ├─ Server validates username on join               │
│  └─ Non-whitelisted users get no GUI                │
│                                                      │
│  Layer 2: Admin Detection                           │
│  ├─ Server checks admin status                      │
│  └─ Only admins see admin characters                │
│                                                      │
│  Layer 3: Ability Validation                        │
│  ├─ Server checks CE availability                   │
│  ├─ Server checks cooldown status                   │
│  └─ Server validates character selection            │
│                                                      │
│  Layer 4: Server-Side Execution                     │
│  ├─ All game logic runs on server                   │
│  ├─ Client only handles UI and input                │
│  └─ No client-side ability execution                │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## Key Features Summary

✅ **Access Control**: Whitelist + Admin system
✅ **Character System**: 10 characters, 75 abilities
✅ **GUI System**: Selection menu + Ability panel
✅ **Game Systems**: CE management + Cooldowns
✅ **Architecture**: Clean client-server separation
✅ **Security**: Server-side validation
✅ **Performance**: Optimized update loops
✅ **Code Quality**: Modern Luau best practices
✅ **Documentation**: 6 comprehensive guides
✅ **Modularity**: Easy to extend and customize

---

**Status**: ✅ Production Ready
**Version**: 1.0.0
**Last Updated**: December 2024
