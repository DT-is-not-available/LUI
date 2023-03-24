return function(str)
	local table_tostring = require("LUI.table_tostring")
	return load(str, nil, 't', {
		table = {unpack(table)},
		string = {unpack(string)},
		math = {unpack(math)},
		getmetatable = getmetatable,
		pairs = pairs,
		ipairs = ipairs,
		next = next,
		pcall = pcall,
		rawequal = rawequal,
		rawget = rawget,
		rawlen = rawlen,
		rawset = rawset,
		select = select,
		setmetatable = setmetatable,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		_VERSION = _VERSION,
		xpcall = xpcall,
		print = function(...)
			local args = {...}
			for i, v in ipairs(args) do
				if type(v) ~= "string" then
					args[i] = table_tostring(v)
				end
			end
			print(unpack(args))
		end,
	})()
end