
local TimerTime = 20 -- seconds
local MAX_TRY = 3 -- max recurve count
local Initial_Load = Initial_Load or false -- is first time loaded?



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


local function hookRemoverFunc(count)
	if (count) and (count >= MAX_TRY) then return end
	local hoooks, funcs = hook.GetTable()
	for hookType, hookTbl in pairs(hookRemove) do
		for hookName, _ in pairs(hookTbl) do
			if hoooks[hookType] and hoooks[hookType][hookName] then
				hook.Remove(hookType, hookName)
			end
		end
	end
	timerRemoverFunc()

	timer.Simple(TimerTime, function()

		hookRemoverFunc((count or 0) + 1)
	end)
end

if (!Initial_Load) then
	hookRemoverFunc()
end


local oldTime = timer.Simple

function timer.Simple(numb,func)

	local data = debug.getinfo(func)

	if timerSimples[data.short_src] then return end

	oldTime(numb, func)
end


