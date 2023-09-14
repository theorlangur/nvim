return {
  'f-person/git-blame.nvim',
  event = {"BufReadPost", "BufNewFile"},
  config = function ()
    local gb = require('gitblame')
    gb.setup{ enabled = 1 }
    vim.keymap.set('n', '<leader>gg', ':GitBlameToggle<cr>', { desc = "To[g]gle [G]it Blame line" })
  end
}
