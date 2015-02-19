local _M = require("newmodule")(...)

_M._COPYRIGHT   = "Copyright (c) 2012 Olivine Labs, LLC."
_M._DESCRIPTION = "A simple string key/value store for i18n or any other case where you want namespaced strings."
_M._VERSION     = "Say 1.2"

local registry = {}
local current_namespace
local fallback_namespace

local s = {}

function _M:set_namespace(namespace)
	current_namespace = namespace
	if not registry[current_namespace] then
		registry[current_namespace] = {}
	end
end

function _M:set_fallback(namespace)
	fallback_namespace = namespace
	if not registry[fallback_namespace] then
		registry[fallback_namespace] = {}
	end
end

function _M:set(key, value)
	registry[current_namespace][key] = value
end

local __meta = {
	__call = function(self, key, vars)
		vars = vars or {}

		local str = registry[current_namespace][key] or registry[fallback_namespace][key]

		if str == nil then
			return nil
		end
		str = tostring(str)
		local strings = {}

		for i,v in ipairs(vars) do
			table.insert(strings, tostring(v))
		end

		return #strings > 0 and str:format(unpack(strings)) or str
	end,

	__index = function(self, key)
		return registry[key]
	end
}

_M:set_fallback('en')
_M:set_namespace('en')

--if _TEST then
--	s._registry = registry -- force different name to make sure with _TEST behaves exactly as without _TEST
--end

return setmetatable(s, __meta)
