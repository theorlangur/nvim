return {
  "theorlangur/vs-tasks.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local vstasks = require('vstask')
    local cfg = {}
    if vim.loop.os_uname().version:find('Windows') then
      cfg.shell = "powershell.exe"
    end
    vstasks.setup(cfg)
    local clear_inputs = vstasks.Telescope.Clear_inputs
    local ts = require('telescope')
    vim.keymap.set('n', '<leader>ta', ts.extensions.vstask.tasks, { desc = 'Run VSCode tasks' })
    vim.keymap.set('n', '<leader>ti', ts.extensions.vstask.inputs, { desc = 'Run VSCode inputs' })
    vim.keymap.set('n', '<leader>tc', clear_inputs, { desc = 'Clear VSCode inputs' })
  end
}
