return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},

	config = function()
		vim.lsp.set_log_level("DEBUG")
		vim.g.lspconfig_ts_ls = 1 -- Mark that we're handling ts_ls

		-- Debug: print when ts_ls tries to start
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
			callback = function()
				-- print("FileType triggered for: " .. vim.bo.filetype)
				-- print("Active clients: " .. #vim.lsp.get_active_clients())
			end,
		})

		-- Create debug command
		-- vim.api.nvim_create_user_command('LspSettings', function()
		--   local clients = vim.lsp.get_active_clients()
		--   for _, client in ipairs(clients) do
		--     if client.name == 'ts_ls' then
		--       -- print(vim.inspect({
		--       --   init_options = client.config.init_options,
		--       --   settings = client.config.settings
		--       -- }))
		--     end
		--   end
		-- end, {})

		-- Get capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Setup Mason
		-- ts_ls, eslint-lsp, stylua, lua_ls
		require("mason").setup()
		-- require("mason-lspconfig").setup({
		--   automatic_installation = false, -- Changed to false!
		--   ensure_installed = {
		--     "lua_ls",
		--     "ts_ls",
		--   },
		--   handlers = {
		--     -- Disable default handler completely
		--     function(server_name)
		--       if server_name == "ts_ls" then
		--         return
		--       end
		--     end,
		--   },
		-- })

		-- Setup servers manually AFTER mason-lspconfig
		local lspconfig = require("lspconfig")

		-- Lua LS
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
					},
					telemetry = { enable = false },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})

		-- TypeScript/JavaScript LS
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			init_options = {
				hostInfo = "neovim",
				preferences = {
					importModuleSpecifierPreference = "relative",
					importModuleSpecifierEnding = "minimal",
				},
			},
			settings = {
				typescript = {
					format = { enable = false },
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
						importModuleSpecifierPreference = "relative",
						importModuleSpecifierEnding = "minimal",
					},
				},
				javascript = {
					format = { enable = false },
				},
			},
		})

		-- ESLint (only if installed)
		lspconfig.eslint.setup({
			capabilities = capabilities,
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = false, -- Disable this
					},
				},
				codeActionOnSave = {
					enable = false,
					mode = "all",
				},
			},
			-- Only use eslint for diagnostics, not code actions
			on_attach = function(client, bufnr)
				client.server_capabilities.codeActionProvider = false
			end,
		})
		-- Java JDTLS
		lspconfig.jdtls.setup({
			capabilities = capabilities,
			settings = {
				java = {
					contentProvider = { preferred = "fernflower" },
					format = { enabled = true },
					maven = { downloadSources = true },
					referencesCodeLens = { enabled = true },
					implementationsCodeLens = { enabled = true },
					signatureHelp = { enabled = true },
					completion = {
						enabled = true,
						favoriteStaticMembers = {
							"org.junit.Assert.*",
							"org.mockito.Mockito.*",
						},
						filteredTypes = {
							"com.sun.*",
							"java.awt.*",
							"sun.*",
						},
					},
				},
			},
		})

		-- Keymaps
		local key_opts = {}
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, key_opts)
		vim.keymap.set("n", "gcf", vim.lsp.buf.format, key_opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, key_opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, key_opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, key_opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, key_opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, key_opts)
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, key_opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, key_opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, key_opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, key_opts)

		-- Diagnostic config
		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})
	end,
}
