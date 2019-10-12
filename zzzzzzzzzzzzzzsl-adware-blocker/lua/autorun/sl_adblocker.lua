local hookRemove = {
	["PlayerSpawn"] = {
		["z"] = true,
	},
	["Think"] = {
		["sfdgsadf"] = true,
		["freeLoadingNerds"] = true,
		["robotBoy Loves Me <3"] = true,
	},
	["HUDPaint"] = {
		["drawOurName"] = true,
	}
}

local timerRemove = {
	"Repeat timer msg",
}

local timerRemoverFunc = function()
	for _, timerName in ipairs(timerRemove) do
		if timer.Exists(timerName) then
			timer.Remove(timerName)
		end
	end
end

local hookRemoverFunc = function()
	local hoooks, funcs = hook.GetTable()
	for hookType, hookTbl in pairs(hookRemove) do
		for hookName, _ in pairs(hookTbl) do
			if hoooks[hookType] and hoooks[hookType][hookName] then
				hook.Remove(hookType, hookName)
			end
		end
	end
	timerRemoverFunc()
end


hookRemoverFunc()
timer.Simple(10, function()
	hookRemoverFunc()
end)
