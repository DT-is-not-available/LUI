return function (t)
	local function ansi(s, codes, endcodes)
		codes = codes or {}
		endcodes = endcodes or {}
		return '\027['..table.concat({0, unpack(codes)}, ";")..'m'.. s .. '\027['..table.concat({0, unpack(endcodes)}, ";")..'m'
	end
	local function escString(str)
		str = str or ""
		return ansi('"'..
			string.gsub(
				string.gsub(
					string.gsub(
						string.gsub(str, '"', ansi('\\"', {95, 100}, {33}))
					, '\n', ansi('\\n', {95, 100}, {33}))
				, '\t', ansi('\\t', {95, 100}, {33}))
			, '\r', ansi('\\r', {95, 100}, {33}))
		..'"', {33})
	end
	local function dump(o, i)
		i = i or 0
		if type(o) == 'table' then
			local s = '{\n'
			for k,v in pairs(o) do
				if type(k) == 'string' then
					if string.match(k, "^[%a_][%a_%d]*$") then
						k = ansi(k, {94})
					else
						k = '['..escString(k)..']' 
					end
				elseif type(k) == "number" then
					k = '['..ansi(k, {92})..']'
				else
					k = '['..ansi(k, {34})..']'
				end
				s = s .. string.rep('    ', i+1) .. k .. ' = ' .. dump(v, i+1) .. ',\n'
			end
			return s .. string.rep('    ', i) .. '}'
		else
			if type(o) == "string" then
				return escString(o)
			elseif type(o) == "number" then
				return ansi(tostring(o), {92})
			else
				return ansi(tostring(o), {34})
			end
		end
	end
	return dump(t)
end