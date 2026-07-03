local langs = {
	"vimdoc",
	"javascript",
	"typescript",
	"tsx",
	"c",
	"lua",
	"rust",
	"jsdoc",
	"bash",
	"markdown",
}

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({})

		require("nvim-treesitter").install(langs)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function(args)
				local ft = args.match
				local ok, parser = pcall(vim.treesitter.language.get_parser, 0, ft)
				if ok and parser then
					vim.treesitter.start()
				end
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = langs,
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
