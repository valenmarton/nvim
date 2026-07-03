-- Ensure mason and Homebrew binaries are on PATH (macOS + Linux)
local path_prefixes = {
  vim.fn.stdpath("data") .. "/mason/bin",
  "/opt/homebrew/bin",
  "/usr/local/bin",
}
for i = #path_prefixes, 1, -1 do
  if vim.fn.isdirectory(path_prefixes[i]) == 1 then
    vim.env.PATH = path_prefixes[i] .. ":" .. vim.env.PATH
  end
end

-- neovim-remote for opening file from lazygit in neovim instance
if vim.fn.executable("nvr") == 1 then
  vim.env.GIT_EDITOR = "nvr --remote-tab-wait +'set bufhidden=delete'"
else
  -- print("nvr not found in PATH, git commit messages will not open in Neovim")
end

vim.api.nvim_create_user_command("SetCwdToCurrentFile", function()
  local current_file = vim.fn.expand("%:p")
  local current_directory = vim.fn.fnamemodify(current_file, ":h")
  local clean_path = string.gsub(current_directory, "^oil://", "")
  -- print("root dir: " .. clean_path)
  vim.cmd("lcd " .. vim.fn.fnameescape(clean_path))
  -- vim.cmd("lcd " .. vim.fn.fnameescape(current_directory))
  -- for NETRW
  -- local current_file = vim.fn.expand("%:p")
  -- local current_directory = vim.fn.fnamemodify(current_file, ":h")
  -- print("root dir: " .. current_directory)
  -- vim.cmd("lcd " .. vim.fn.fnameescape(current_directory))
end, {})

-- Create the autocmd group
vim.cmd([[
augroup cdpwd
    autocmd!
    autocmd VimEnter * SetCwdToCurrentFile
augroup END
]])

local function is_eslint_lsp_available_and_compatible()
  -- Get active LSP clients
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name == "eslint" then
      local success, err = pcall(function()
        vim.cmd("EslintFixAll")
      end)

      if not success then
        print("Error while running EslintFixAll: " .. err)
      else
        print("EslintFixAll ran successfully!")
      end
      return true
    end
  end
end

-- TODO: optional because eslint config: AutoFixOnSave is not working, so calling in manually
-- Autoformat & run eslint on js/ts files
-- INFO: for eslint formatting
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     callback = function()
--         local mode = vim.api.nvim_get_mode().mode
--         local filetype = vim.bo.filetype
--         local modified = vim.bo.modified
--         if filetype == 'oil' then
--             return
--         end
--         if modified == true and mode == 'n' then
--             vim.lsp.buf.format()
--         end
--         if filetype == 'javascript' or filetype == 'typescript' then
--             is_eslint_lsp_available_and_compatible()
--         end
--     end
-- })

-- loading plugins
require("config.lazy")
-- loading basic settings & keymaps
require("config.set")
require("config.remap")
