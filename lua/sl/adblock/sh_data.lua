---@class SL.AdBlock.Data
---@field addons table<number, table> Blocked addons by workshop ID
---@field functions table<string, table> Blocked functions by realm (sv/cl/sh)
---@field hooks table<string, table> Hooks to remove
---@field timers table<string, table> Timers to remove

SL = SL or {}
SL.AdBlock = SL.AdBlock or {}

---@type SL.AdBlock.Data Current blacklist data
SL.AdBlock.Data = SL.AdBlock.Data or {}

---Fetches the latest blacklist data from the remote server
---@param callback function?(results) Optional callback called with the fetched data
function SL.AdBlock.FetchBlacklist(callback)
	http.Fetch(SL.AdBlock.Config.DataUrl, function(body, size, headers, code)
		if not body then return end

		local jsonData = util.JSONToTable(body)
		if not jsonData then return end

		SL.AdBlock.Data = jsonData
		-- This logic should be moved out of here in the future

		if not file.Exists(SL.AdBlock.Config.StorageFolder, "DATA") then
			file.CreateDir(SL.AdBlock.Config.StorageFolder)
		end

		file.Write(SL.AdBlock.Config.StoragePath, body)

		SL.AdBlock.Logger.Info("Fetched blacklist data successfully")

		if callback then
			callback(SL.AdBlock.Data)
		end
	end, function(err)
		if err then
			SL.AdBlock.Logger.Error("Failed to fetch blacklist:", err)
		end
	end)
end

---Loads blacklist data from local storage
function SL.AdBlock.LoadFromStorage()
	local fileData = file.Read(SL.AdBlock.Config.StoragePath, "DATA")
	if not fileData then
		SL.AdBlock.Logger.Warn("No stored data found. Restart required.")
	end

	local jsonData = util.JSONToTable(fileData)
	if not jsonData then return {} end
	SL.AdBlock.Data = jsonData
	-- This logic should be moved out of here in the future

	return jsonData
end

---Gets the current blacklist data
---@return SL.AdBlock.Data The blacklist data table
function SL.AdBlock.GetData()
	return SL.AdBlock.Data
end

---Checks if blacklist data has been loaded
---@return boolean Whether data exists and is not empty
function SL.AdBlock.HasData()
	return SL.AdBlock.Data and next(SL.AdBlock.Data) ~= nil
end

---Gets the blocked functions from blacklist data
---@return table The blocked functions by realm
function SL.AdBlock.GetFunctions()
	return SL.AdBlock.Data.functions or {}
end

---Gets the hooks to remove from blacklist data
---@return table The hooks to remove
function SL.AdBlock.GetHooks()
	return SL.AdBlock.Data.hooks or {}
end

---Gets the timers to remove from blacklist data
---@return table The timers to remove
function SL.AdBlock.GetTimers()
	return SL.AdBlock.Data.timers or {}
end

---Gets the blocked addons from blacklist data
---@return table The blocked addons by workshop ID
function SL.AdBlock.GetAddons()
	return SL.AdBlock.Data.addons or {}
end