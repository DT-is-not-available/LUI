local LUI = require("LUI.init")
local benchmark = require("benchmarker")
table.tostring = require("LUI.table_tostring")
printval = function(...)
	local args = {...}
	for i, value in ipairs(args) do
		args[i] = table.tostring(value)
	end
	print(unpack(args))
end
function input(msg)
	print(msg)
	io.write("\027[38;5;77m\027[0m ")
	return io.read()
end

local bm = benchmark()

bm.start("page build time")

local style = LUI.style [[
p {
	background: red;
	color: blue;
}
div > #cool {
	background: green;
	padding: 20px;
}
p {
	font: arial;
}
]]

bm.checkpoint("style parsing")

local src = [[
<body>
	<title @template>
		Hello world!
		<br/>
		<??>
		<?arg>
	</title>
	<br/>
	<p>Lorem ipsum dolor sit amit.</p>
	<@template arg=hello>
		
	</@template>
	<? .d .e onclick=(function()
		print("Wow! That's crazy!")
	end)>
		<div id="cool">AAA</div>
		<div>Oh no?</?>
		<div #beans .a .b .c test=37 disabled >BBB</div>
	</?>
	<div #beans .a .b .c test=37 disabled >BBB</div>
</body>
]]

local document = LUI.luml(src)

bm.checkpoint("luml parsing")

document:build()

bm.checkpoint("document:build")

document:link(style)

bm.checkpoint("document:link")

print(document)

bm.lap("page load")

---[[

for i = 1, 1000, 1 do
	local doc = LUI.luml(src)
end

bm.checkpoint("just parse\t\t\t", 1000)

for i = 1, 1000, 1 do
	local doc = LUI.luml(src)
	doc:build()
end

bm.checkpoint("parse + build\t\t", 1000)

for i = 1, 1000, 1 do
	local doc = LUI.luml(src)
	doc:build()
	doc:link(style)
end

bm.checkpoint("parse + build + link", 1000)

--]]

bm.lap("mass test")

bm.print()