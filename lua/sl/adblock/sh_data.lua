SL = SL or {}
SL.AdBlock = SL.AdBlock or {}
SL.AdBlock.Data = SL.AdBlock.Data or {}

function SL.AdBlock.FetchBlacklist(callback)
	http.Fetch(SL.AdBlock.Config.DataUrl, function(body, size, headers, code)
		if not body then return end

		local jsonData = util.JSONToTable(body)
		if not jsonData then return end

		SL.AdBlock.Data = jsonData

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

function SL.AdBlock.LoadFromStorage()
	local fileData = file.Read(SL.AdBlock.Config.StoragePath, "DATA")
	if not fileData then
		SL.AdBlock.Logger.Warn("No stored data found. Restart required.")
		return
	end

	local jsonData = util.JSONToTable(fileData)
	if not jsonData then return end

	SL.AdBlock.Data = jsonData
	return
end

function SL.AdBlock.GetData()
	return SL.AdBlock.Data
end

function SL.AdBlock.HasData()
	return SL.AdBlock.Data and next(SL.AdBlock.Data) ~= nil
end

function SL.AdBlock.GetFunctions()
	return SL.AdBlock.Data.functions or {}
end

function SL.AdBlock.GetHooks()
	return SL.AdBlock.Data.hooks or {}
end

function SL.AdBlock.GetTimers()
	return SL.AdBlock.Data.timers or {}
end

function SL.AdBlock.GetAddons()
	return SL.AdBlock.Data.addons or {}
end