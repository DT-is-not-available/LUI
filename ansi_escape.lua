return function(s, codes)
	return '\0x1b['..table.concat(codes, ";")..'m'.. s .. '\0x1b[0m'
end