return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>vd", "<cmd>Gvdiffsplit<cr>")
	end,
}
