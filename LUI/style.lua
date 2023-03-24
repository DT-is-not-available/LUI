return function(css)
	local styles = {}
	local ids = {}
	for s, r in string.gmatch(css, "([^%{%s][^%{]*)(%b{})") do
		local selector = {}
		for v, O in string.gmatch(s, "([^<>%s]*)(%S?)") do
			if #v > 0 then
				table.insert(selector, v)
			end
			if #O > 0 then
				table.insert(selector, O)
			end
		end
		local rules = {}
		for key, val in string.gmatch(r, "([%w%-]*)%s*:%s*([^;]*)") do
			rules[key] = val
		end
		local id = ids[table.concat(selector, " ")]
		if id == nil then
			ids[table.concat(selector, " ")] = #styles+1
			table.insert(styles, {
				selector = selector,
				rules = rules
			})
		else
			for key, value in pairs(rules) do
				styles[id].rules[key] = value
			end
		end
	end
	return styles
end