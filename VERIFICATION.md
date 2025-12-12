# System Verification Checklist

## ✅ Pre-Installation Checklist

Before installing the JJK Roblox System, verify you have:

- [ ] Roblox Studio installed and updated
- [ ] A place/game opened in Roblox Studio
- [ ] Access to ReplicatedStorage
- [ ] Access to ServerScriptService
- [ ] Access to StarterPlayer > StarterPlayerScripts

## ✅ File Verification

### Shared Modules (3 files)
- [ ] `src/shared/Config.lua` exists
- [ ] `src/shared/CharacterData.lua` exists
- [ ] `src/shared/AbilityData.lua` exists

### Server Scripts (2 files)
- [ ] `src/server/PlayerData.server.lua` exists
- [ ] `src/server/AbilityHandler.server.lua` exists

### Client Scripts (3 files)
- [ ] `src/client/CharacterSelectGUI.client.lua` exists
- [ ] `src/client/AbilityInfoPanel.client.lua` exists
- [ ] `src/client/InputHandler.client.lua` exists

## ✅ Installation Verification

After installation in Roblox Studio:

### ReplicatedStorage Structure
- [ ] `ReplicatedStorage/JJKShared` folder exists
- [ ] `JJKShared/Config` ModuleScript exists
- [ ] `JJKShared/CharacterData` ModuleScript exists
- [ ] `JJKShared/AbilityData` ModuleScript exists

### ServerScriptService Structure
- [ ] `ServerScriptService/PlayerData` Script exists
- [ ] `ServerScriptService/AbilityHandler` Script exists

### StarterPlayerScripts Structure
- [ ] `StarterPlayer/StarterPlayerScripts/CharacterSelectGUI` LocalScript exists
- [ ] `StarterPlayer/StarterPlayerScripts/AbilityInfoPanel` LocalScript exists
- [ ] `StarterPlayer/StarterPlayerScripts/InputHandler` LocalScript exists

## ✅ Configuration Verification

- [ ] Whitelist configured in `Config.lua`
- [ ] Your username added to whitelist
- [ ] Admin list configured (optional)

## ✅ Runtime Verification

When you press "Play" in Roblox Studio:

### Output Window Messages
Look for these initialization messages in the Output window:
- [ ] `[JJK] PlayerData server initialized`
- [ ] `[JJK] AbilityHandler server initialized`
- [ ] `[JJK GUI] Character selection GUI initialized for [Username]`
- [ ] `[JJK GUI] Ability info panel initialized`
- [ ] `[JJK Input] Input handler initialized`
- [ ] `[JJK] Player [Username] joined (Admin: true/false)`

### ReplicatedStorage Runtime
During play mode, check ReplicatedStorage:
- [ ] `ReplicatedStorage/JJKRemotes` folder appears
- [ ] `JJKRemotes/SelectCharacter` RemoteEvent exists
- [ ] `JJKRemotes/UseAbility` RemoteEvent exists
- [ ] `JJKRemotes/GetPlayerData` RemoteFunction exists
- [ ] `JJKRemotes/GetAbilityInfo` RemoteFunction exists
- [ ] `JJKRemotes/AbilityEffect` RemoteEvent exists

### Visual Verification
- [ ] Character selection menu visible in top-left corner
- [ ] Menu shows "JJK Characters" title
- [ ] "Regular Characters" section visible
- [ ] "Admin Characters" section visible (if admin)
- [ ] 5 regular character buttons visible

### Interaction Verification
- [ ] Clicking a character button selects it
- [ ] Output shows: `[JJK GUI] Selected character: [Name]`
- [ ] Button briefly changes color on click
- [ ] Server confirms: `[JJK] [Username] selected character: [Name]`

### Ability Panel Verification
- [ ] Press `K` key to open panel
- [ ] Panel slides in from left side
- [ ] Panel shows "Abilities" title
- [ ] Character name displayed (or "No character selected")
- [ ] CE bar visible with text "CE: 500/500"
- [ ] Ability cards visible in scrollable area
- [ ] Each card shows: Name, Type, Damage, CE Cost, Cooldown
- [ ] Press `K` again to close panel
- [ ] Panel slides out to left

### Ability Usage Verification
- [ ] Select a character first
- [ ] Press number key 1-5 (regular) or 1-0 (admin)
- [ ] Output shows: `[JJK Input] Pressed ability key: [X]`
- [ ] Server confirms: `[JJK] [Username] used [Ability] (Damage: X)`
- [ ] CE decreases (if not admin)
- [ ] Cooldown starts (if not admin)

## ✅ Character Data Verification

### Regular Characters (5 characters, 5 abilities each = 25 total)
- [ ] Gojo (Satoru Gojo)
- [ ] Sukuna (Ryomen Sukuna)
- [ ] Megumi (Megumi Fushiguro)
- [ ] Yuji (Yuji Itadori)
- [ ] Todo (Aoi Todo)

### Admin Characters (5 characters, 10 abilities each = 50 total)
- [ ] Gojo (Admin)
- [ ] Sukuna (Admin)
- [ ] Megumi (Admin)
- [ ] Yuji (Admin)
- [ ] Todo (Admin)

## ✅ Ability System Verification

### Regular Character Abilities
- [ ] Each has 3 Attack abilities
- [ ] Each has 1 Defense ability
- [ ] Each has 1 Ultimate ability
- [ ] All have CE costs (10-100)
- [ ] All have cooldowns (2-50s)
- [ ] Ultimate has 50s cooldown

### Admin Character Abilities
- [ ] Each has 10 abilities
- [ ] All have 0 CE cost
- [ ] All have 0 cooldown
- [ ] Higher damage values
- [ ] Includes Domain Expansion ability

## ✅ Feature Verification

### Access Control
- [ ] Only whitelisted users see GUI
- [ ] Non-whitelisted users get no GUI
- [ ] Admin users see admin characters
- [ ] Non-admin users don't see admin characters

### CE System
- [ ] CE starts at 500/500
- [ ] CE decreases when using abilities (non-admin)
- [ ] CE regenerates at 5 per second
- [ ] CE stops regen for 2s after ability use
- [ ] CE bar updates visually
- [ ] Admins don't lose CE

### Cooldown System
- [ ] Cooldowns start after ability use (non-admin)
- [ ] Cooldowns prevent ability spam
- [ ] Cooldown timers count down
- [ ] Admins have no cooldowns
- [ ] Display shows "None (Admin)" for admins

## 🐛 Troubleshooting

If any verification fails:

1. **Check script locations** - Ensure all files are in correct places
2. **Check script types** - Server scripts are Scripts, client scripts are LocalScripts
3. **Check Output window** - Look for error messages in red
4. **Check names** - Folder and script names must match exactly
5. **Check whitelist** - Your username must be in Config.lua whitelist
6. **Restart Studio** - Sometimes helps with initialization issues

## 📊 Expected Values

### Character Counts
- Regular characters: 5
- Admin characters: 5
- Total characters: 10
- Regular abilities: 25 (5×5)
- Admin abilities: 50 (5×10)
- Total abilities: 75

### Whitelist
- Default whitelisted: 02Drop, donavn
- Add your username to test

### Stats
- Max CE: 500
- CE Regen: 5/second
- Regen Delay: 2 seconds
- Ultimate Cooldown: 50 seconds

## ✅ Final Verification

System is fully operational when:
- [ ] All files installed correctly
- [ ] All scripts initialize without errors
- [ ] GUI appears for whitelisted users
- [ ] Character selection works
- [ ] Ability panel opens with K key
- [ ] Abilities can be used with number keys
- [ ] CE and cooldowns function correctly
- [ ] Output shows no red error messages

## 🎉 Success!

If all items are checked, your JJK Roblox System is fully operational!

Enjoy using your Jujutsu Kaisen ability system!
