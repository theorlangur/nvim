vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
--vim.g.gitblame_enabled = 0

require 'system_id'
require 'opts'
require 'basic_keys'
require 'session_management'
require 'lazycfg'

require 'mycpp'
require 'clangd_restart'
require 'markdown'
require 'myxml'
require 'quickfix'
require 'copy_line_number'
 
require('custom.lsp_current_function')

require 'local_configs'
if SYSTEM_ID.zephyr then
  require 'local_zephyr_config'
end

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.keymap.set('n', '<leader>gr', ':Git fetch | Git rebase origin/master<cr>', { desc = "Fetch-and-rebase" })
vim.keymap.set('n', '<leader>gcm', ':Git checkout master<cr>', { desc = "Checkout master" })
vim.keymap.set('n', '<leader>gcd', ':Git checkout DimaExp<cr>', { desc = "Checkout DimaExp" })
vim.keymap.set('n', '<leader>gmff', ':Git merge --ff-only DimaExp<cr>', { desc = "Merge fast-forward from DimaExp" })
vim.keymap.set('n', '<leader>gp', ':Git push<cr>', { desc = "Git Push" })
vim.keymap.set('n', '<leader>gb', ':Git blame<cr>', { desc = "Git Blame" })
vim.keymap.set('n', '<leader>ghb', ':!perl tools/beautify/beautify.pl -git<cr>', { desc = "Git pre-commit beautify -git" })
vim.keymap.set('n', '<leader>ghB', ':!perl tools/beautify/beautify.pl -git -gitcached<cr>', { desc = "Git pre-commit beautify -git cached" })
vim.keymap.set('n', '<leader>ggp', ':!.\\tools\\generate_projects\\generate_projects.exe force<cr>', { desc = "Generate Projects" })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

vim.lsp.enable({'clangd', 'lua_ls', 'rust_analyzer'})
