vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
--vim.g.gitblame_enabled = 0

require 'opts'
require 'basic_keys'
require 'lazycfg'

require 'mycpp'
require 'myxml'
 
local tele_tasks = require ('custom.tele_tasks')
--local git_blame = require('custom.git_blame_hint')
require('custom.lsp_current_function')

vim.keymap.set('n', '<leader>b', tele_tasks.tasks_picker, { desc = 'Run a [B]uild task' })
--vim.keymap.set('n', '<leader>gb', git_blame.blame_current_line, { desc = '[G]it [B]lame current line' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
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
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
