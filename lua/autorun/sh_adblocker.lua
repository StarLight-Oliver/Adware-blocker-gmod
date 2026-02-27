local function AddCSFile(path)
	if SERVER then
		AddCSLuaFile(path)
	end
end

AddCSFile("sl/adblock/sh_config.lua")
AddCSFile("sl/adblock/sh_data.lua")
AddCSFile("sl/adblock/sh_blocker.lua")
AddCSFile("sl/adblock/sh_hooks.lua")
AddCSFile("sl/adblock/sh_init.lua")

include("sl/adblock/sh_config.lua")
include("sl/adblock/sh_data.lua")
include("sl/adblock/sh_blocker.lua")
include("sl/adblock/sh_hooks.lua")
include("sl/adblock/sh_init.lua")
