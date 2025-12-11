# Quick Installation Guide

## Step-by-Step Setup

### 1. Prepare ReplicatedStorage

In Roblox Studio:
1. Open ReplicatedStorage in Explorer
2. Insert a new Folder
3. Rename it to `JJKShared`
4. Inside `JJKShared`, create 4 ModuleScripts:
   - Name them: `Config`, `CharacterData`, `AbilityData`, `AbilityHandler`
5. Copy the code from the corresponding files:
   - `src/shared/Config.lua` → `Config` ModuleScript
   - `src/shared/CharacterData.lua` → `CharacterData` ModuleScript
   - `src/shared/AbilityData.lua` → `AbilityData` ModuleScript
   - `src/shared/AbilityHandler.lua` → `AbilityHandler` ModuleScript

### 2. Setup Server Scripts

1. Open ServerScriptService in Explorer
2. Create 1 Script (NOT LocalScript):
   - Name it: `PlayerData`
3. Copy the code:
   - `src/server/PlayerData.server.lua` → `PlayerData` Script

### 3. Setup Client Scripts

1. Open StarterPlayer → StarterPlayerScripts in Explorer
2. Create 3 LocalScripts:
   - Name them: `CharacterSelectGUI`, `AbilityInfoPanel`, `InputHandler`
3. Copy the code:
   - `src/client/CharacterSelectGUI.client.lua` → `CharacterSelectGUI` LocalScript
   - `src/client/AbilityInfoPanel.client.lua` → `AbilityInfoPanel` LocalScript
   - `src/client/InputHandler.client.lua` → `InputHandler` LocalScript

### 4. Configure Whitelist

1. Open ReplicatedStorage → JJKShared → Config
2. Modify the whitelist:

```lua
Config.Whitelist = {
    "YourUsername",  -- Replace with your Roblox username
    "02Drop",
    "donavn"
}

Config.Admins = {
    "YourUsername",  -- Replace with your Roblox username
    "02Drop",
    "donavn"
}
```

### 5. Test the Game

1. Click "Play" in Roblox Studio
2. You should see:
   - Character selection menu in top-left corner
   - Press `K` to open ability panel
3. Check Output window for initialization messages:
   - `[JJK] PlayerData server initialized`
   - `[JJK] AbilityHandler server initialized`
   - `[JJK GUI] Character selection GUI initialized`

## Troubleshooting

### Menu not showing?
- Check if your username is in the whitelist
- Check Output for errors
- Ensure all scripts are in correct locations

### "JJKShared not found" error?
- Make sure the folder is named exactly `JJKShared`
- Check that it's in ReplicatedStorage
- Ensure ModuleScripts are inside it

### Abilities not working?
- Make sure you selected a character first
- Check that RemoteEvents are created (look for JJKRemotes in ReplicatedStorage during play)
- Check Output for error messages

## Hierarchy Structure

Your Explorer should look like this:

```
ReplicatedStorage
└── JJKShared (Folder)
    ├── Config (ModuleScript)
    ├── CharacterData (ModuleScript)
    ├── AbilityData (ModuleScript)
    └── AbilityHandler (ModuleScript)

ServerScriptService
└── PlayerData (Script)

StarterPlayer
└── StarterPlayerScripts
    ├── CharacterSelectGUI (LocalScript)
    ├── AbilityInfoPanel (LocalScript)
    └── InputHandler (LocalScript)
```

## Notes

- Server scripts will automatically create the `JJKRemotes` folder in ReplicatedStorage
- The GUI will automatically appear for whitelisted players
- Admin characters only appear for admin users
