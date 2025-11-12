return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},

			vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<cr>"),
			vim.keymap.set("n", "<leader>dt", "<cmd>Gitsigns diffthis<cr>"),
			vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>"),
			vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>"),
			vim.keymap.set("n", "<leader>vh", "<cmd>Gitsigns preview_hunk<cr>"),
		})
	end,
}
