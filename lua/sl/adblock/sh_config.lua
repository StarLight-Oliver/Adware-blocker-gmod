---@class SL.AdBlock.Config
---@field DataUrl string URL to fetch blacklist data from
---@field StorageFolder string Folder name for local storage
---@field StoragePath string Full path to storage file
---@field TimerRetryInterval number Seconds between retry attempts
---@field MaxRetryAttempts number Maximum number of hook/timer removal retries

SL = SL or {}
SL.AdBlock = SL.AdBlock or {}

SL.AdBlock.Config = SL.AdBlock.Config or {}

---@type string URL to fetch blacklist data from
SL.AdBlock.Config.DataUrl = "https://github.com/StarLight-Oliver/Adware-blocker-gmod/raw/master/data/adware_block/data.json"

---@type number Seconds between retry attempts for hook/timer removal
SL.AdBlock.Config.TimerRetryInterval = 20

---@type number Maximum number of retry attempts for hook/timer removal
SL.AdBlock.Config.MaxRetryAttempts = 3

-- These should be set to the same value + filename for the storage path.

---@type string Folder name for local data storage
SL.AdBlock.Config.StorageFolder = "adware_block"

---@type string Full path to the local storage file
SL.AdBlock.Config.StoragePath = "adware_block/data.json"
