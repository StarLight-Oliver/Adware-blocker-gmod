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

		if callback then
			callback(SL.AdBlock.Data)
		end
	end, function(err)
		if err then
			print("[AdBlock] Failed to fetch blacklist:", err)
		end
	end)
end

function SL.AdBlock.LoadFromStorage()
	local fileData = file.Read(SL.AdBlock.Config.StoragePath, "DATA")
	if not fileData then
		print("[AdBlock] No stored data found. Restart required.")
		return false
	end

	local jsonData = util.JSONToTable(fileData)
	if not jsonData then return false end

	SL.AdBlock.Data = jsonData
	return true
end

function SL.AdBlock.GetData()
	return SL.AdBlock.Data
end

function SL.AdBlock.HasData()
	return SL.AdBlock.Data and next(SL.AdBlock.Data) ~= nil
end
