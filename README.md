# AdBlock for Garry's Mod

A server-side addon that blocks malicious addons from running unwanted code, such as advertisement popups, and other invasive behaviors.

## Features

- Blocks known malicious addons based on Workshop ID
- Automatically removes blocked hooks and timers
- Overrides dangerous functions to prevent execution
- Auto-updates blacklist from remote server
- Supports server, client, and shared realms

## Installation

1. Download the latest release
2. Extract to your Garry's Mod server's `garrysmod/addons/` folder
3. The addon will automatically initialize on server start

## Structure

```
lua/sl/adblock/
├── sh_config.lua    # Configuration and settings
├── sh_logger.lua    # Logging utilities
├── sh_data.lua      # Blacklist data management
├── sh_blocker.lua   # Function override system
├── sh_hooks.lua     # Hook/timer removal
└── sh_init.lua      # Initialization
```

## Configuration

All configuration is in `sh_config.lua`.

### DataUrl

The remote URL to fetch blacklist data from. Should not be changed unless you host your own blacklist.

### TimerRetryInterval

Number of seconds between retry attempts when removing hooks and timers. Default is 20.

### MaxRetryAttempts

Maximum number of retry attempts for removing hooks and timers. Default is 3.

### StorageFolder

The folder name used for local data storage. Default is "adware_block".

### StoragePath

The full path to the local storage file. Default is "adware_block/data.json".

### Changing Log Level

```lua
-- Set to debug for verbose logging
SL.AdBlock.Logger.SetLevel(SL.AdBlock.Logger.Levels.DEBUG)
```

Available levels: `DEBUG`, `INFO`, `WARN`, `ERROR`

## API

### Functions

- `SL.AdBlock.FetchBlacklist(callback)` - Fetch latest blacklist from server
- `SL.AdBlock.LoadFromStorage()` - Load blacklist from local cache
- `SL.AdBlock.ApplyOverrides()` - Apply function overrides for blocked addons
- `SL.AdBlock.ScanAddons(silent)` - Scan installed addons and build blocklist
- `SL.AdBlock.RemoveHooks(retryCount)` - Remove blocked hooks (with retry)
- `SL.AdBlock.RemoveTimers()` - Remove blocked timers
- `SL.AdBlock.OverrideFunction(funcName, blockedFiles)` - Override a function
- `SL.AdBlock.FindAddonFiles(addonTitle)` - Get files for an addon

### Accessors

- `SL.AdBlock.GetData()` - Get current blacklist data
- `SL.AdBlock.HasData()` - Check if data is loaded
- `SL.AdBlock.GetFunctions()` - Get blocked functions
- `SL.AdBlock.GetHooks()` - Get hooks to remove
- `SL.AdBlock.GetTimers()` - Get timers to remove
- `SL.AdBlock.GetAddons()` - Get blocked addons

## Automatic Updates

The addon fetches the latest blacklist from a remote server on startup. As long as your server has internet access, the blacklist stays current. No manual updates required.

## Credits

- **StarLight** - Base code and refactor
- **Nicolas** - Workshop ID blocking
- **Nykez** - Dynamic data loading
- **Luiggi33** - Fixed Steam HTTP error
- **Herminatar** - Icon base
- **The Doctor** - Addon discovery
- **Vaas** - Addon discovery
- **woha** - Addon discovery
