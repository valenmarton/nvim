return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"saghen/blink.cmp",
	},

	config = function()
		-- ------------------------------------------------------------------
		-- Logging (disable once stable)
		-- ------------------------------------------------------------------
		vim.lsp.set_log_level("DEBUG")

		-- ------------------------------------------------------------------
		-- Capabilities (blink.cmp)
		-- ------------------------------------------------------------------
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- ------------------------------------------------------------------
		-- Mason (ONLY installs binaries)
		-- ------------------------------------------------------------------
		require("mason").setup()

		-- ------------------------------------------------------------------
		-- Lua Language Server
		-- ------------------------------------------------------------------
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = {
							"vim",
							"bit",
							"it",
							"describe",
							"before_each",
							"after_each",
						},
					},
					telemetry = { enable = false },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})

		-- ------------------------------------------------------------------
		-- TypeScript / JavaScript Language Server
		-- ------------------------------------------------------------------
		vim.lsp.config("ts_ls", {
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
					},
				},
				javascript = {
					format = { enable = false },
				},
			},
		})

		-- ------------------------------------------------------------------
		-- ESLint (diagnostics ONLY, no code actions)
		-- ------------------------------------------------------------------
		vim.lsp.config("eslint", {
			capabilities = capabilities,
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = false,
					},
				},
				codeActionOnSave = {
					enable = false,
					mode = "all",
				},
			},
			on_attach = function(client)
				client.server_capabilities.codeActionProvider = false
			end,
		})

		-- ------------------------------------------------------------------
		-- Java (JDTLS)
		-- ------------------------------------------------------------------
		vim.lsp.config("jdtls", {
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

		-- ------------------------------------------------------------------
		-- Enable servers (IMPORTANT!)
		-- ------------------------------------------------------------------
		vim.lsp.enable({
			"lua_ls",
			"ts_ls",
			"eslint",
			"jdtls",
		})

		-- ------------------------------------------------------------------
		-- Keymaps
		-- ------------------------------------------------------------------
		local key_opts = {}

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, key_opts)

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, key_opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, key_opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, key_opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, key_opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, key_opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, key_opts)

		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, key_opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, key_opts)
		vim.keymap.set("n", "gl", vim.diagnostic.open_float, key_opts)

		-- ------------------------------------------------------------------
		-- Diagnostics UI
		-- ------------------------------------------------------------------
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
