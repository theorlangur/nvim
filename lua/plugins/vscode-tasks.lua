return {
  "theorlangur/vs-tasks.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local vstasks = require('vstask')
    local _sh = nil
    if vim.loop.os_uname().version:find('Windows') then
      _sh = "powershell.exe"
    end
    vstasks.setup({shell=_sh})
    local ts = require('telescope')
    vim.keymap.set('n', '<leader>ta', ts.extensions.vstask.tasks, { desc = 'Run VSCode tasks' })
    vim.keymap.set('n', '<leader>ti', ts.extensions.vstask.inputs, { desc = 'Run VSCode inputs' })
  end
}
