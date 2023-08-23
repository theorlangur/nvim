local dap = require('dap')
local dapui = require('dapui')
local is_win = vim.loop.os_uname().version:find('Windows')

dapui.setup()
require('neodev').setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

--Key bindings---
vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<CR>', {desc="Toggle Breakpoint"})
vim.keymap.set('n', '<leader>dr', ':DapContinue<CR>', {desc="Start/Continue debug execution"})
vim.keymap.set('n', '<leader>dx', ':DapTerminate<CR>', {desc="Terminate debugging"})
vim.keymap.set('n', 'F10', ':DapStepOver<CR>', {desc="Step Over"})
vim.keymap.set('n', 'F11', ':DapStepInto<CR>', {desc="Step Into"})
vim.keymap.set('n', 'F12', ':DapStepOut<CR>', {desc="Step Out"})
vim.keymap.set({'n', 'v'}, '<Leader>dh', require('dap.ui.widgets').hover, {desc="DAP: hover"})
--End of key bindings---

if is_win then
  --TODO: find ms-vscode.cpptools independently of version
  dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = 'C:\\Users\\DmitryD\\.vscode\\extensions\\ms-vscode.cpptools-1.16.3-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe',
    options = {
      detached = false
    }
  }

  dap.adapters.cppvsdbg = {
    id = 'cppvsdbg',
    type = 'executable',
    command = 'C:\\Users\\DmitryD\\.vscode\\extensions\\ms-vscode.cpptools-1.16.3-win32-x64\\debugAdapters\\vsdbg\\bin\\vsdbg.exe',
    args = {
      '--interpreter=vscode'
    },
    options = {
      detached = false
    }
  }

  dap.adapters.lldb = {
    id = 'lldb',
    type = 'executable',
    command = 'c:\\Program Files\\LLVM\\bin\\lldb-vscode.exe',
  }

  dap.adapters.codelldb = {
    id = 'codelldb',
    type = 'server',
    port = '3344',
    executable = {
      command = 'C:\\Users\\DmitryD\\.vscode\\extensions\\vadimcn.vscode-lldb-1.9.2\\adapter\\codelldb.exe',
      args = {'--port', '3344'},
    }
  }
else
  dap.adapters.lldb = {
    id = 'lldb',
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
  }
end
