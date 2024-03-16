return {
  'cbochs/grapple.nvim',
  opts = {
    scope = "git",
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons", lazy=true },
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  config = function()
    vim.keymap.set('n', '<leader>m', "<cmd>Grapple toggle<cr>", { desc = 'Grapple toggle tag' })
    vim.keymap.set('n', '<leader>hl', "<cmd>Grapple toggle_tags<cr>", { desc = 'Grapple toggle tags' })
    vim.keymap.set('n', '<leader>1', "<cmd>Grapple select index=1<cr>", { desc = 'Grapple select 1' })
    vim.keymap.set('n', '<leader>2', "<cmd>Grapple select index=2<cr>", { desc = 'Grapple select 2' })
    vim.keymap.set('n', '<leader>3', "<cmd>Grapple select index=3<cr>", { desc = 'Grapple select 3' })
    vim.keymap.set('n', '<leader>4', "<cmd>Grapple select index=4<cr>", { desc = 'Grapple select 4' })
  end
}
