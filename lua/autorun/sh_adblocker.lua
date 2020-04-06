
local TimerTime = 20 -- seconds
local MAX_TRY = 3 -- max recurve count
local Initial_Load = Initial_Load or false -- is first time loaded?
local data = data or {}

local RAW_URL = "https://github.com/nykez/Adware-blocker-gmod/raw/master/data/adware_block/data.json"

-- Remove all timers that match at the given execution time
local function timerRemoverFunc()
	for k, v in pairs(data.timers) do
		if (timer.Exists(k)) then
			timer.Remove(k)
		end
	end
end



-- Remove all hooks that match at the given execution time
local function hookRemoverFunc(count)
	if (count) and (count >= MAX_TRY) then return end
	local hoooks, funcs = hook.GetTable()
	for hookType, hookTbl in pairs(data.hooks or {}) do
		for hookName, _ in pairs(hookTbl) do
			if hoooks[hookType] and hoooks[hookType][hookName] then
				print('removed hook')
				hook.Remove(hookType, hookName)
			end
		end
	end
	timerRemoverFunc()

	timer.Simple(TimerTime, function()

		hookRemoverFunc((count or 0) + 1)
	end)
end


local oldTime = timer.Simple

-- Overwrite timer.Simple to remove timers per file-name.
function timer.Simple(numb,func)

	local fileInfo = debug.getinfo(func)

	if (data) and (data.timerFiles) and (data.timerFiles[fileInfo.short_src]) then return end

	oldTime(numb, func)
end

-- Fetches new blacklist data via github
local function GetBlacklistData(fncCallback)
	http.Fetch(RAW_URL, function(body, size, headers, code)
		if (body) then
			data = util.JSONToTable(body)

			if (data) then
				if (fncCallback) then
					fncCallback(data)
				end
			else
				if (fncCallback) then
					fncCallback(false)
				end
			end
		end
	end,
	function(err)
		if (err) then
			print(err)
		end
	end)
end

-- Read our hard-storage file for blacklists
-- Prolly outdated
local function ReadHardStorage()
	local fileData = file.Read("adware_block/data.json", "DATA")

	if (fileData) then
		data = util.JSONToTable(fileData)
		hookRemoverFunc()
	else
		print("[Adware Block] Failed to get hard-storage data. Please reinstall.")
	end
end


if (!Initial_Load) then
	GetBlacklistData(function(results)
		if (results) then
			hookRemoverFunc()
		else
			-- couldn't get new data, fallback to hard storage.
			print("[Adware Block] Failed to get blacklist github data. Using hard-storage (maybe out of date)")
			ReadHardStorage()
		end
	end)
end
