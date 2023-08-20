local dap = require('dap')
local dapui = require('dapui')

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
