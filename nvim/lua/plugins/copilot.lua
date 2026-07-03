return {
	{
		"github/copilot.vim",
		enabled = false,
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.api.nvim_set_keymap("i", "<Del>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				silent = true,
			})

			vim.keymap.set("i", "<C-Del>", "<Plug>(copilot-dismiss)", {
				silent = true,
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		enabled = true,
		build = "make tiktoken",
		opts = {},
		keys = {
			{ "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" },
		},
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		cmd = "Copilot",
		event = "InsertEnter",
		config = true,
		opts = {
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<Del>",
					refresh = "gr",
					open = "<M-CR>",
				},
				layout = {
					position = "bottom", -- | top | left | right | horizontal | vertical
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				trigger_on_accept = true,
				keymap = {
					accept = "<Del>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-Del>",
				},
			},
		},
	},
}
