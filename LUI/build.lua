return function (document)
	local sandbox = require("LUI.sandbox")
	-- go through docuenmt, flatten grouping and expand templates
	local function search(doc, parent)
		-- do build stuff
		if type(doc) == "string" then
			return doc
		end
		local children = {}
		if doc.children then
			for k, v in pairs(doc.attributes) do
				if type(v) == "table" and v.expr then
					doc.attributes[k] = sandbox("return "..v.expr)
				end
			end
			for _, child in ipairs(doc.children) do
				search(child, doc)
				if child.tag == "?" then
					-- flatten groupings
					for _, groupedChild in ipairs(child.children) do
						table.insert(children, groupedChild)
						for k,v in pairs(child.attributes) do 
							if not groupedChild.attributes[k] then
								-- value does not exist
								groupedChild.attributes[k] = v 
							elseif k == ":class" then
								-- value is a class table
								for _, class in ipairs(v) do
									table.insert(groupedChild.attributes[k], class)
								end
							end
						end
					end
				else
					-- append child as per usual
					table.insert(children, child)
				end
			end
		end
		doc.children = children
		return doc
	end
	return search(document, nil)
end