# LUI
Lua library for rendering [LUML](luml-specification.md)

![<progress fill green value=14 max=100></progress>](https://progress-bar.dev/14/?title=prototype&width=200)

todo:

<link rel="stylesheet" href="docs.css"></link>

![lui <progress red value=29 max=100></progress>](https://progress-bar.dev/29/?title=lui&width=80)
- [x] luml - parse LUML file
- [ ] element:build - flattens groupings and expands templates
	- [x] flatten groupings
	- [ ] remove templates from element list
	- [ ] expand templates
	- [x] evaluate expressions
	- [ ] link class getters
	- [ ] link id getters
- [ ] element:link - internally links styles
	- [ ] link style rules
- [ ] style - parse CSS file
- [x] sandbox - env which all code runs in
- [ ] element api
- [ ] (e) matching lang - better matching past patterns
- [ ] (e) luax? like jsx but lua

![lui render <progress red value=0 max=2></progress>](https://progress-bar.dev/0/?title=lui%20render&width=80)
- [ ] lui-core - core rendering engine and interaction binding
	- [ ] element draw func
	- [ ] default style rules
	- [ ] interaction bindings for elements
- [ ] lui-std - standard default styles and interaction bindings for common tags like `<button>`