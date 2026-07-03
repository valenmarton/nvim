return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    local opts = {}

    require("telescope").setup({
      defaults = {
        path_display = { "truncate" },
        layout_config = {
          vertical = { width = 0.8 },
          horizontal = { width = 0.8 },
          -- prompt_position = "top",
          -- mirror = true,
        },
        layout_strategy = "horizontal",
        -- pickers = {
        --     find_files =
        --
        -- },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
    })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:

    local builtin = require("telescope.builtin")

    local function find_files_opts()
      if vim.fn.executable("rg") == 1 then
        return {
          hidden = true,
          no_ignore = true,
          prompt_prefix = "All files > ",
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--glob", "!**/node_modules/*",
            "--glob", "!**/.git/*",
            "--glob", "!**/dist/*",
            "--glob", "!**/tmp/*",
            "--glob", "!**/.idea/*",
          },
        }
      end
      return {
        hidden = true,
        no_ignore = true,
        prompt_prefix = "All files > ",
      }
    end

    -- search for hidden files too
    vim.keymap.set("n", "<C-p>", function()
      builtin.find_files(find_files_opts())
    end, {})
    -- find directories
    -- vim.keymap.set("n", "<leader>fd", function()
    -- 	builtin.find_files({
    -- 		-- hidden = true,                    -- Include hidden files (files starting with a dot)
    -- 		prompt_prefix = "Directories > ", -- Custom title for the picker
    -- 		-- :Telescope fd find_command=fd,-t=d
    -- 		find_command = { "find", ".", "-type", "d" }, -- only find directories
    -- 	})
    -- end, {})
    -- dependencies: fd
    vim.keymap.set("n", "<leader>fd", function()
      if vim.fn.executable("fd") == 1 then
        builtin.find_files({
          prompt_prefix = "Directories > ",
          find_command = { "fd", "-t", "d", "--ignore-file", ".gitignore" },
        })
      else
        vim.notify("fd not found — install with: brew install fd", vim.log.levels.WARN)
      end
    end, {})
    vim.keymap.set("n", "<leader>sql", builtin.quickfix, {})
    vim.keymap.set("n", "<leader>sqh", builtin.quickfixhistory, {})
    vim.keymap.set("n", "<leader><leader>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, {})
    vim.keymap.set("n", "<leader>ps", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)

    vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
    vim.keymap.set("n", "<leader>ht", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, {})
    vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, {})
    vim.keymap.set("n", "<leader>km", builtin.keymaps, {})
    vim.keymap.set("n", "<leader>of", builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>ic", builtin.lsp_incoming_calls, {})
    vim.keymap.set("n", "gr", function()
      builtin.lsp_references({ include_declaration = false, fname_width = 100 })
    end, { desc = "Search references" })
    vim.keymap.set("n", "<leader>gr", function()
      builtin.lsp_references({ include_declaration = false, fname_width = 100 })
    end, { desc = "Search references" })
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_definitions<cr>", opts)
    vim.keymap.set("n", "<leader>ls", "<cmd>Telescope resume<cr>", opts)
    -- Change colorscheme
    vim.keymap.set("n", "<leader>cs", "<cmd>Telescope colorscheme<cr>", opts)

    -- vim.keymap.set("n", "<leader>sw", function()
    -- 	local word = vim.fn.expand("<cword>")
    -- 	builtin.grep_string({ search = word })
    -- end)

    vim.keymap.set("n", "<leader>sW", function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)

    vim.keymap.set("n", "<leader>sr", builtin.oldfiles, {}) --search recent

    -- <leader>sr could be search references, currently in lsp config (gr)

    vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, {}) --search symbols

    vim.keymap.set("n", "<leader>,", function()
      builtin.buffers({ sort_mru = true, ignore_current_buffer = true })
    end)

    vim.keymap.set("n", "<leader>.", builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set("n", "<leader>/", function()
      builtin.live_grep({})
    end)
  end,
}
