SL = SL or {}
SL.AdBlock = SL.AdBlock or {}

function SL.AdBlock.RemoveTimers()
	local timers = SL.AdBlock.GetTimers()

	for name, _ in pairs(timers) do
		if timer.Exists(name) then
			timer.Remove(name)
		end
	end
end

function SL.AdBlock.RemoveHooks(retryCount)
	if retryCount and retryCount >= SL.AdBlock.Config.MaxRetryAttempts then
		return
	end

	local existingHooks = hook.GetTable()
	local storedHooks = SL.AdBlock.GetHooks()

	for hookType, hookTable in pairs(storedHooks) do
		for hookName, _ in pairs(hookTable) do
			if existingHooks[hookType] and existingHooks[hookType][hookName] then
				hook.Remove(hookType, hookName)
			end
		end
	end

	SL.AdBlock.RemoveTimers()

	timer.Simple(SL.AdBlock.Config.TimerRetryInterval, function()
		SL.AdBlock.RemoveHooks((retryCount or 0) + 1)
	end)
end
