SL.AdBlock.Initialized = SL.AdBlock.Initialized or false

function SL.AdBlock.Initialize()
	if SL.AdBlock.Initialized then return end
	SL.AdBlock.Initialized = true

	SL.AdBlock.LoadFromStorage()
	SL.AdBlock.ApplyOverrides()
	SL.AdBlock.RemoveHooks()

	timer.Simple(0, function()
		SL.AdBlock.FetchBlacklist(function(results)
			if not results then
				print("[AdBlock] Failed to fetch updated blacklist. Using stored data.")
				SL.AdBlock.LoadFromStorage()
			end

			SL.AdBlock.RemoveHooks()
			SL.AdBlock.ScanAddons(true)
		end)
	end)
end

SL.AdBlock.Initialize()
