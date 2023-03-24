return function(tbl)
	local function ansi(s, codes, endcodes)
		codes = codes or {}
		endcodes = endcodes or {}
		return '\027['..table.concat({0, unpack(codes)}, ";")..'m'.. tostring(s) .. '\027['..table.concat({0, unpack(endcodes)}, ";")..'m'
	end
	-- colors
	local blue = {38, 5, 27}
	local gray = {38, 5, 248}
	local darkgray = {38, 5, 248, 2, 5}
	local sky = {38, 5, 153}
	local brown = {38, 5, 173}
	local yellow = {38, 5, 228}
	local teal = {38, 5, 36}
	local purple = {38, 5, 177}
	local function attribString(tbl, i)
		i = i or 0
		local prestr = ""
		local midstr = ""
		local attribs = {}
		for k, v in pairs(tbl) do
			if k == ":id" then
				prestr = ansi("#")..ansi(v, yellow, gray)..prestr
			elseif k == ":template" then
				midstr = ansi(" @")..ansi(v, purple, gray)
			elseif k == ":class" then
				prestr = prestr..ansi(".")..ansi(table.concat(v, ansi(".", {0}, teal)), teal, gray)
			else
				local str = ansi(k, sky, gray)
				if type(v) ~= 'boolean' then
					str = str..ansi("=")..ansi('"'..tostring(v)..'"', brown, gray)
				end
				table.insert(attribs, str)
			end
		end
		local len = (#prestr > 0 and 1 or 0) + #attribs
		if len > 3 then
			return prestr .. midstr .. "\n" .. string.rep("    ", i+1) .. table.concat(attribs, "\n" .. string.rep("    ", i+1)) .. " "
		else
			if #attribs > 0 then
				return prestr .. midstr .. " " .. table.concat(attribs, " ")
			else
				return prestr .. midstr
			end
		end
	end
	local function viewSpace(str)
		return string.gsub(
			string.gsub(str, "(\t+)", function(tabs)
				return ansi(string.rep("→\t", #tabs), darkgray)
			end), "( +)", function(spaces)
			return ansi(string.rep("·", #spaces), darkgray)
		end)
	end
	local function dump(o, i)
		i = i or 0
		if type(o) == 'table' then
			local tag
			if string.match(o.tag, "^?") and #o.tag > 1 then
				tag = ansi("?")..ansi(string.gsub(o.tag, "?", "", 1), purple, gray)
			elseif string.match(o.tag, "^@") and #o.tag > 1 then
				tag = ansi("@")..ansi(string.gsub(o.tag, "@", "", 1), purple, gray)
			else
				tag = ansi(o.tag, blue, gray)
			end
			local opentag = tag..attribString(o.attributes, i)
			if #o.children == 0 then
				return ansi('<'..opentag..'/>',gray)
			elseif #o.children == 1 and type(o.children[1]) == "string" then
				return ansi('<'..opentag..'>',gray)..
					viewSpace(o.children[1])
				.. ansi('</'..ansi(o.tag, blue, gray)..'>',gray)
			else
				local s = ansi('<'..opentag..'>',gray)..'\n'
				for _, v in ipairs(o.children) do
					s = s .. string.rep('    ', i+1) .. dump(v, i+1) .. '\n'
				end
				return s .. string.rep('    ', i) .. ansi('</'..ansi(o.tag, blue, gray)..'>',gray)
			end
		else
			return ansi('"', gray)..viewSpace(o)..ansi('"', gray)
		end
	end
	return dump(tbl)
end