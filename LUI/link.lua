return function (document, style)
	-- go through docuenmt, match up styles with selectors
	local function search(doc, ...)
		
		if type(doc) == "string" then
			return doc
		end
		local path = {...}
		table.insert(path, doc)
		local styles = {}
		for _, st in pairs(style) do
			for _, value in ipairs(path) do
				if st.selector[0] == value then
					table.insert(styles, st.rules)
				end
			end
		end
		doc.styles = styles
		for _, child in ipairs(doc.children) do
			search(child, unpack(path))
		end
		return doc
	end
	return search(document)
end