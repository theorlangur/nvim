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
require 'config_debug'
require 'config_text_objects'

require 'mycpp'
require 'myxml'

local tele_tasks = require ('tele_tasks')
local git_blame = require('git_blame_hint')

vim.keymap.set('n', '<leader>b', tele_tasks.tasks_picker, { desc = 'Run a [B]uild task' })
vim.keymap.set('n', '<leader>gb', git_blame.blame_current_line, { desc = '[G]it [B]lame current line' })

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


--[[
local wspTest = "d:\\Developing\\grandma_main\\gma3"
local dap = require('dap')
dap.configurations.cpp = {
  {
      name = "app_gma3 win debug",
      type = "cppdbg",
      request = "launch",
      program = wspTest.."/obj/windows/gma3/Debug/app_gma3.exe",
      cwd = wspTest,
      args = {
          "debug",
          "HOSTTYPE=onPC"
          ,"unlimparam"
      },
      miDebuggerPath="d:\\Developing\\tmp\\llvm-mingw-20230614-msvcrt-x86_64\\llvm-mingw-20230614-msvcrt-x86_64\\bin\\lldb-mi.exe",
      visualizerFile = wspTest.."/tools/dbg_visualizers/msvc/gma3_combined.combinednatvis",
  },
}
dap.configurations.cpp = {
  {
      name = "app_gma3 win debug",
      type = "lldb",
      request = "launch",
      program = wspTest.."/obj/windows/gma3/Debug/app_gma3.exe",
      cwd = wspTest,
      args = {
          "debug",
          "HOSTTYPE=onPC"
          ,"unlimparam"
      },
      --miDebuggerPath="C:\\Users\\DmitryD\\.vscode\\extensions\\ms-vscode.cpptools-1.16.3-win32-x64\\debugAdapters\\vsdbg\\bin\\vsdbg.exe",
      --visualizerFile = wspTest.."/tools/dbg_visualizers/msvc/gma3_combined.combinednatvis",
  },
}
dap.configurations.cpp = {
  {
      name = "app_gma3 win debug",
      type = "codelldb",
      request = "launch",
      program = wspTest.."/obj/windows/gma3/Debug/app_gma3.exe",
      cwd = wspTest,
      args = {
          "debug",
          "HOSTTYPE=onPC"
          ,"unlimparam"
      },
      stopOnEntry = false
      --miDebuggerPath="C:\\Users\\DmitryD\\.vscode\\extensions\\ms-vscode.cpptools-1.16.3-win32-x64\\debugAdapters\\vsdbg\\bin\\vsdbg.exe",
      --visualizerFile = wspTest.."/tools/dbg_visualizers/msvc/gma3_combined.combinednatvis",
  },
}
]]
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
