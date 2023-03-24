return function ()
	local benchmark = {}
	local function ansi(s, codes, endcodes)
		codes = codes or {}
		endcodes = endcodes or {}
		return '\027['..table.concat({0, unpack(codes)}, ";")..'m'.. tostring(s) .. '\027['..table.concat({0, unpack(endcodes)}, ";")..'m'
	end
	return {
		start = function(msg)
			benchmark = {
				start = os.clock(),
				time = os.clock(),
				total = os.clock(),
				message = "\tbenchmark: "..msg,
				lineLength = #msg+18,
			}
		end,
		checkpoint = function(msg, divisor)
			divisor = divisor or 1
			local line = ansi(msg, {32}, {90}) .. "\t-\t" .. ansi(string.format("%f", os.clock() - benchmark.start), {94, 4}) ..
				" (took " .. ansi(string.format("%f", os.clock() - benchmark.time), {95, 4}) .. ")"
			if #line-35 > benchmark.lineLength then
				benchmark.lineLength = #line-35
			end
			if (divisor ~= 1) then
				line = line .. ansi("\n| ", {32}) .. ansi(divisor, {93, 3, 1}) .. " rounds avg. " .. ansi(string.format("%f", (os.clock() - benchmark.time)/divisor), {91, 4}) .. " each"
			end
			benchmark.message = 
				benchmark.message .. "\n" .. 
				line
			benchmark.time = os.clock()
		end,
		lap = function(msg)
			local line = 'lap ' .. ansi(msg, {31}, {90}) .. "\t-\t" .. ansi(string.format("%f", os.clock() - benchmark.start), {96, 4})
			benchmark.message = 
				benchmark.message .. "\n" .. 
				line
			benchmark.time = os.clock()
			benchmark.start = os.clock()
		end,
		print = function(msg)
			print(
				ansi(string.rep("-", benchmark.lineLength), {31}) .. "\n" ..
				benchmark.message .. "\n" .. "total: " .. ansi(os.clock() - benchmark.total, {33, 1, 4}) .. "\n" ..
				ansi(string.rep("-", benchmark.lineLength), {31})
			)
		end,
	}
end