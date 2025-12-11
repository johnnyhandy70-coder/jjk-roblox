# JJK Roblox System

A complete Jujutsu Kaisen ability system for Roblox with character selection GUI and ability management.

## Features

- **Character Selection Menu**: Top-left scrollable menu with regular and admin characters
- **Ability Info Panel**: Press `K` to view detailed ability information
- **Whitelisted Access**: Only authorized users can access the system
- **Admin Characters**: Special admin-only characters with 10 abilities, no CE costs, and no cooldowns
- **CE System**: Cursed Energy management with regeneration
- **Cooldown System**: Ability cooldowns with tracking

## Characters

### Regular Characters (5 abilities each)
- Gojo (Satoru Gojo)
- Sukuna (Ryomen Sukuna)
- Megumi (Megumi Fushiguro)
- Yuji (Yuji Itadori)
- Todo (Aoi Todo)

### Admin Characters (10 abilities each)
- Gojo (Admin)
- Sukuna (Admin)
- Megumi (Admin)
- Yuji (Admin)
- Todo (Admin)

## Installation

### Setup in Roblox Studio

1. **Create Folders in ReplicatedStorage**:
   - Create a folder named `JJKShared` in ReplicatedStorage
   - Place the following ModuleScripts inside `JJKShared`:
     - `Config` (from `src/shared/Config.lua`)
     - `CharacterData` (from `src/shared/CharacterData.lua`)
     - `AbilityData` (from `src/shared/AbilityData.lua`)

2. **Server Scripts**:
   - Place `PlayerData.server.lua` in ServerScriptService
   - Place `AbilityHandler.server.lua` in ServerScriptService

3. **Client Scripts**:
   - Create a folder in StarterPlayer > StarterPlayerScripts (or StarterGui)
   - Place all client scripts as LocalScripts:
     - `CharacterSelectGUI.client.lua`
     - `AbilityInfoPanel.client.lua`
     - `InputHandler.client.lua`

### Configuration

Edit `Config.lua` to add whitelisted users:

```lua
Config.Whitelist = {
    "02Drop",
    "donavn",
    -- Add more usernames here
}

Config.Admins = {
    "02Drop",
    "donavn",
    -- Add admin usernames here
}
```

## Controls

- **Number Keys 1-5**: Use abilities (regular characters)
- **Number Keys 1-0**: Use abilities (admin characters)
- **K Key**: Open/Close ability info panel

## Usage

1. Start the game in Roblox Studio
2. Whitelisted players will see the character selection menu in the top-left corner
3. Click a character to select it
4. Press `K` to view abilities and stats
5. Use number keys (1-5 or 1-0) to activate abilities

## File Structure

```
src/
├── server/
│   ├── AbilityHandler.server.lua    - Handles ability execution and effects
│   └── PlayerData.server.lua        - Manages player data, CE, and cooldowns
├── client/
│   ├── CharacterSelectGUI.client.lua - Character selection menu
│   ├── AbilityInfoPanel.client.lua   - Ability information panel (K key)
│   └── InputHandler.client.lua       - Input handling for abilities
├── shared/
│   ├── CharacterData.lua             - Character definitions
│   ├── AbilityData.lua               - Ability data and utilities
│   └── Config.lua                    - Configuration and whitelist
```

## Access Control

- **Whitelisted Users**: Can access the system and use regular characters
- **Admin Users**: Can access both regular and admin characters
- **Non-whitelisted Users**: Cannot see or interact with the system

## System Details

### Cursed Energy (CE)
- Max CE: 500
- Regen Rate: 5 CE per second
- Regen Delay: 2 seconds after ability use
- Admins have 0 CE cost for all abilities

### Cooldowns
- Regular abilities: 2-12 seconds
- Ultimate abilities: 50 seconds
- Admins have no cooldowns

### Ability Types
- **Attack**: Offensive abilities that deal damage
- **Defense**: Defensive abilities for protection
- **Ultimate**: Powerful ultimate abilities
- **Buff**: Stat enhancement abilities
- **Mobility**: Movement abilities
- **CC**: Crowd control abilities
- **Domain**: Domain Expansion abilities (admin only)

## Extending the System

### Adding New Characters

1. Edit `CharacterData.lua`
2. Add character to `RegularCharacters` or `AdminCharacters`
3. Follow the existing format with abilities array

### Adding New Abilities

Abilities should follow this structure:
```lua
{
    Name = "Ability Name",
    Type = "Attack",  -- Attack, Defense, Ultimate, Buff, Mobility, CC, Domain
    Damage = 50,
    CECost = 20,      -- 0 for admin abilities
    Cooldown = 5      -- 0 for admin abilities
}
```

## Credits

Created for the Jujutsu Kaisen Roblox game.

## License

This project is for educational and entertainment purposes.