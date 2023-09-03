vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.cmd.colorscheme("evening")

require 'opts'
require 'basic_keys'
require 'plugins-vscode'

require 'mycpp'
require 'mycpp-vscode'
require 'myxml'

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
