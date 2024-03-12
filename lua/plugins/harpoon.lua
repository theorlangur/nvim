return {
  'ThePrimeagen/harpoon',
  branch='harpoon2',
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local h = require('harpoon')
    h:setup()

    vim.keymap.set('n', '<leader>ha', function() h:list():append() end, { desc = '[h]arpoon [a]ppend' })
    vim.keymap.set('n', '<leader>hl', function() h.ui:toggle_quick_menu(h:list()) end, { desc = '[h]arpoon [l]ist' })
    vim.keymap.set('n', '<leader>he', function() h:list():select(1) end, { desc = '[h]arpoon select 1' })
    vim.keymap.set('n', '<leader>hr', function() h:list():select(2) end, { desc = '[h]arpoon select 2' })
    vim.keymap.set('n', '<leader>ht', function() h:list():select(3) end, { desc = '[h]arpoon select 3' })
    vim.keymap.set('n', '<leader>hp', function() h:list():prev() end, { desc = '[h]arpoon [p]rev' })
    vim.keymap.set('n', '<leader>hn', function() h:list():next() end, { desc = '[h]arpoon [n]ext' })
  end
}
