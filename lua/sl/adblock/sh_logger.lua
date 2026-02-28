---@class SL.AdBlock.Logger
---@field Prefix string Prefix for all log messages
---@field Levels table<string, number> Log level definitions
---@field MinLevel number Minimum log level to output

SL.AdBlock.Logger = SL.AdBlock.Logger or {}

---@type string Prefix for all log messages
SL.AdBlock.Logger.Prefix = "[AdBlock]"

---@type table<string, number> Log level definitions
SL.AdBlock.Logger.Levels = {
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4
}

---@type number Minimum log level to output (default: INFO)
SL.AdBlock.Logger.MinLevel = SL.AdBlock.Logger.Levels.INFO

---Sets the minimum log level for output
---@param level number The minimum level to log (e.g., SL.AdBlock.Logger.Levels.DEBUG)
function SL.AdBlock.Logger.SetLevel(level)
	SL.AdBlock.Logger.MinLevel = level
end

---Log a debug message
---@param ... any Message parts to log
function SL.AdBlock.Logger.Debug(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.DEBUG then return end
	print(SL.AdBlock.Logger.Prefix .. " [DEBUG]", ...)
end

---Log an info message
---@param ... any Message parts to log
function SL.AdBlock.Logger.Info(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.INFO then return end
	print(SL.AdBlock.Logger.Prefix .. " [INFO]", ...)
end

---Log a warning message
---@param ... any Message parts to log
function SL.AdBlock.Logger.Warn(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.WARN then return end
	print(SL.AdBlock.Logger.Prefix .. " [WARN]", ...)
end

---Log an error message
---@param ... any Message parts to log
function SL.AdBlock.Logger.Error(...)
	if SL.AdBlock.Logger.MinLevel > SL.AdBlock.Logger.Levels.ERROR then return end
	print(SL.AdBlock.Logger.Prefix .. " [ERROR]", ...)
end

---Log a blocked function call
---@param funcName string The function that was blocked
---@param caller string The file that attempted the call
function SL.AdBlock.Logger.Blocked(funcName, caller)
	SL.AdBlock.Logger.Warn("Blocked:", funcName, "call from", caller)
end
