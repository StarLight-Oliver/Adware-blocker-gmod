SL = SL or {}
SL.AdBlock = SL.AdBlock or {}

function SL.AdBlock.RemoveTimers()
	for name, _ in pairs(SL.AdBlock.Timers or {}) do
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
	local storedHooks = SL.AdBlock.Data.hooks or {}

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
