---@class SL.AdBlock.Blocker

SL = SL or {}
SL.AdBlock = SL.AdBlock or {}

---Extracts a specific stack frame from a traceback
---@param stackTrace string The debug traceback string
---@param depthOverride number? Optional depth override (default: 3)
---@return string? The extracted file path
local function extractStackFrame(stackTrace, depthOverride)
	depthOverride = depthOverride or 3

	local lines = string.Explode("\n", stackTrace)
	local frame = lines[depthOverride]
	if not frame then return nil end

	frame = string.Trim(frame)

	if frame:sub(1, 6) == "addons" then
		local pos = frame:find("lua")
		if pos then
			frame = frame:sub(pos)
		end
	end

	local colonPos = frame:find(":")
	if colonPos then
		frame = frame:sub(1, colonPos - 1)
	end

	return frame
end

---Extracts the calling file from the current stack trace
---@param depthOverride number? Optional depth override
---@return string? The calling file path
function SL.AdBlock.ExtractCallingFile(depthOverride)
	return extractStackFrame(debug.traceback(), depthOverride)
end

---Overrides a global function to block calls from specific files
---@param funcName string The name of the function to override (supports dot notation like "chat.AddText")
---@param blockedFiles table<string, boolean> Map of blocked file paths to true
function SL.AdBlock.OverrideFunction(funcName, blockedFiles)
	SL.AdBlock.Logger.Info("Overriding function:", funcName)

	local reference = _G
	local oldFunc = nil
	local name = funcName

	if funcName:find(".") then
		local parts = string.Explode(".", funcName)
		for i = 1, #parts - 1 do
			reference = reference[parts[i]]
			if not reference then
				break
			end
		end
		name = parts[#parts]
	end

	oldFunc = reference[name]
	if not oldFunc then
		SL.AdBlock.Logger.Warn("Could not find function:", funcName)
		return
	end

	local newFunc = function(...)
		local caller = extractStackFrame(debug.traceback())
		if blockedFiles[caller] then
			SL.AdBlock.Logger.Blocked(funcName, caller)
			return
		end
		return oldFunc(...)
	end

	reference[name] = newFunc
end

---Scans an addon's files recursively
---@param addonTitle string The title of the addon to scan
---@return string[] Array of file paths within the addon
function SL.AdBlock.FindAddonFiles(addonTitle)
	local rootDir = "lua"
	local files = {}

	local function scanDir(dir)
		dir = dir .. "/"
		local foundFiles, foundDirs = file.Find(dir .. "*", addonTitle)

		for _, fileName in ipairs(foundFiles) do
			files[#files + 1] = dir .. fileName
		end

		for _, folderName in ipairs(foundDirs) do
			scanDir(dir .. folderName)
		end
	end

	scanDir(rootDir)
	return files
end

---Applies function blocking rules to addon files
---@param blockedRealms table<string, table> Blocked functions by realm
---@param addonFiles string[] Array of addon file paths
---@param functions table The functions table to populate
local function ApplyFunctionBlockingToAddonfiles(blockedRealms, addonFiles, functions)
	for realm, blockedFuncs in pairs(blockedRealms) do
		functions[realm] = functions[realm] or {}

		for _, funcName in pairs(blockedFuncs) do
			functions[realm][funcName] = functions[realm][funcName] or {}

			for _, fileName in ipairs(addonFiles) do
				functions[realm][funcName][fileName] = true
			end
		end
	end
end

---Scans installed addons and builds blocked function mappings
---@param silent boolean? If true, suppresses log output
function SL.AdBlock.ScanAddons(silent)
	local addons = SL.AdBlock.GetAddons()
	if not next(addons) then return end

	local functions = SL.AdBlock.GetFunctions()

	for _, v in SortedPairsByMemberValue(engine.GetAddons(), "title") do
		local wsid = tonumber(v.wsid)
		if not addons[wsid] then continue end

		local addonFiles = SL.AdBlock.FindAddonFiles(v.title)
		local blockedRealms = addons[wsid]

		ApplyFunctionBlockingToAddonfiles(blockedRealms, addonFiles, functions)

		if not silent then
			SL.AdBlock.Logger.Info("Blocked addon (" .. v.title .. ") from running functions")
		end
	end
end

---Applies all function overrides based on blacklist data
function SL.AdBlock.ApplyOverrides()
	SL.AdBlock.ScanAddons()

	local functions = SL.AdBlock.GetFunctions()
	if not functions then return end

	local realm = SERVER and "sv" or "cl"

	for funcName, blockedFiles in pairs(functions[realm] or {}) do
		SL.AdBlock.OverrideFunction(funcName, blockedFiles)
	end

	for funcName, blockedFiles in pairs(functions["sh"] or {}) do
		SL.AdBlock.OverrideFunction(funcName, blockedFiles)
	end
end
