SL.AdBlock.Logger = SL.AdBlock.Logger or {}
SL.AdBlock.Logger.Prefix = "[AdBlock]"
SL.AdBlock.Logger.Levels = {
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4
}
SL.AdBlock.Logger.MinLevel = SL.AdBlock.Logger.Levels.INFO

function SL.AdBlock.Logger.SetLevel(level)
	SL.AdBlock.Logger.MinLevel = level
end

function SL.AdBlock.Logger.Debug(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.DEBUG then return end
	print(SL.AdBlock.Logger.Prefix .. " [DEBUG]", ...)
end

function SL.AdBlock.Logger.Info(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.INFO then return end
	print(SL.AdBlock.Logger.Prefix .. " [INFO]", ...)
end

function SL.AdBlock.Logger.Warn(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.WARN then return end
	print(SL.AdBlock.Logger.Prefix .. " [WARN]", ...)
end

function SL.AdBlock.Logger.Error(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.ERROR then return end
	print(SL.AdBlock.Logger.Prefix .. " [ERROR]", ...)
end

function SL.AdBlock.Logger.Blocked(funcName, caller)
	SL.AdBlock.Logger.Warn("Blocked:", funcName, "call from", caller)
end
