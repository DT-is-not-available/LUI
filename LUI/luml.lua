return function(luml)
	-- original code from http://lua-users.org/wiki/LuaXml
	local luml_tostring = require("LUI.tostring")
	local function parseargs(str)
		local arg = {}
		local s = str
		s = string.gsub(s, "([%-_:%w]+)%s*=%s*([\"'])(.-)%2", function (w, _, a)
			arg[w] = a
			return ''
		end)
		s = string.gsub(s, "([%-_:%w]+)%s*=%s*([%-_:%w]+)", function (w, a)
			arg[w] = a
			return ''
		end)
		s = string.gsub(s, "([%-_:%w]+)%s*=%s*(%b())", function(w, expr)
			arg[w] = {expr=expr}
			return ''
		end)
		s = string.gsub(s, "#([%-_:%w]+)", function (w)
			arg[":id"] = w
			return ''
		end)
		s = string.gsub(s, "@([%-_:%w]+)", function (w)
			arg[":template"] = w
			return ''
		end)
		s = string.gsub(s, "%.([%-_:%w]+)", function (w)
			if arg[":class"] == nil then
				arg[":class"] = {w}
			else
				table.insert(arg[":class"], w)
			end
			return ''
		end)
		s = string.gsub(s, "([%-_:%w]+)", function (w)
			arg[w] = true
			return ''
		end)
		return arg
	end

	local function element(tbl)
		tbl.build = require("LUI.build")
		tbl.link = require("LUI.link")
		return setmetatable(tbl, {
			__tostring = luml_tostring
		})
	end
			
	local function collect(s)
		local stack = {}
		local top = element {
			children = {},
			tag = ":root",
			attributes = {},
		}
		table.insert(stack, top)
		local ni,c,tag,attributes, empty
		local i, j = 1, 1
		while true do
			ni,j,c,tag,attributes, empty = string.find(s, "<(%/?)%s*([%?@%w%-_][%w:%-_]*)(.-)([%/%?]?)>", i)
			if not ni then break end
			local text = string.sub(s, i, ni-1)
			if not string.find(text, "^%s*$") then
				table.insert(top.children, text)
			end
			if empty == "?" and tag == "?" then
				tag = "??"
				empty = "/"
			end
			if empty == "/" or string.match(tag, "^?") and #tag > 1 then	-- empty element tag
				table.insert(top.children, element {tag = tag, attributes = parseargs(attributes), children = {}})
			elseif c == "" then	 -- start tag
				top = element {tag = tag, attributes = parseargs(attributes), children = {}}
				table.insert(stack, top)	 -- new level
			else	-- end tag
				local toclose = table.remove(stack)	-- remove top
				top = stack[#stack]
				if #stack < 1 then
					error("nothing to close with "..tag)
					-- TODO: ignore
				end
				if toclose.tag ~= tag and tag ~= "?" then
					error("trying to close "..toclose.tag.." with "..tag)
					-- TODO: auto close until you find the tag it matches
				end
				table.insert(top.children, toclose)
			end
			i = j+1
		end
		local text = string.sub(s, i)
		if not string.find(text, "^%s*$") then
			table.insert(stack[#stack], text)
		end
		if #stack > 1 then
			error("unclosed "..stack[#stack].label)
			-- TODO: auto close the rest
		end
		return stack[1]
	end

	return collect(luml)
end