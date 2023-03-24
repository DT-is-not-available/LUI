{ pkgs }: {
	deps = [
        pkgs.luajit_2_0
        pkgs.lua
        pkgs.sumneko-lua-language-server
	];
}