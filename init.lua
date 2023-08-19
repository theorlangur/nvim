vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'plugins'
require 'opts'
require 'basic_keys'
require 'config_telescope'
require 'config_treesitter'
require 'config_lsp'
require 'config_completion'
require 'config_nvim_tree'

require 'mycpp'
require 'myxml'

local tele_tasks = require ('tele_tasks')

vim.keymap.set('n', '<leader>b', tele_tasks.tasks_picker, { desc = 'Open diagnostics list' })

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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
