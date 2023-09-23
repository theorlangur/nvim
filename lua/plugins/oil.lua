return {
  'stevearc/oil.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require('oil')
    oil.setup({})
    vim.keymap.set('n', '<leader>F', oil.open_float, { desc = 'Run oil on current buffers dir' })
  end
}
