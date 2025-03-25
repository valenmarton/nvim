return {
	"saghen/blink.cmp",
	tag = "v0.14.2",

	-- optional: provides snippets for the snippet source
	disabled = true,
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- h blink-cmp-config-keymap
		keymap = {
			preset = "super-tab",
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			accept = { auto_brackets = { enabled = false } },
			documentation = { auto_show = true, window = { border = "solid" } },
			list = { selection = { preselect = false, auto_insert = true } },
			menu = {
				-- nvim-cmp style menu
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
