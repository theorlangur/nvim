local dap = require('dap')
local dapui = require('dapui')
local is_win = vim.loop.os_uname().version:find('Windows')

dapui.setup({
  mappings = {
    expand = "L"
  }
})
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
--
---jump to the window of specified dapui element
---@param element string filetype of the element
local function jump_to_element(element)
  local visible_wins = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(visible_wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == element then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.notify(("element '%s' not found"):format(element), vim.log.levels.WARN)
end

local function make_jumper_to(element)
  if element == "" then
    local dapui_filetypes = {
      ["dapui_watches"]=true,
      ["dapui_scopes"]=true,
      ["dapui_breakpoints"]=true,
      ["dapui_stacks"]=true,
      ["dapui_console"]=true,
      ["dap-repl"]=true
    }
    return function()
      local visible_wins = vim.api.nvim_tabpage_list_wins(0)

      for _, win in ipairs(visible_wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if dapui_filetypes[vim.bo[buf].filetype] ~= true then
          vim.api.nvim_set_current_win(win)
          return
        end
      end

      vim.notify("Non-dap-ui element not found", vim.log.levels.WARN)
    end
  else
    return function() jump_to_element(element) end
  end
end

-- list of filetype string of each UI element you can use for jumping.
--"dapui_watches"
--"dapui_scopes"
--"dapui_breakpoints"
--"dapui_stacks"
--"dapui_console"
--"dap-repl"

local function check_cwd_for_launch_lua()
  local cwd = vim.loop.cwd()
  local launch_path = cwd..'/.nvim/launch.lua'
  if vim.loop.fs_stat(launch_path) ~= nil then
    --exists
    local ok, mod = pcall(dofile, launch_path)
    if not ok then
      print("Loading "..launch_path.." failed")
    else
      print("Loaded "..launch_path)
      if type(mod) == "table" then
        for key,value in pairs(mod) do
          dap.configurations[key] = value
        end
      else
        print("Unexpected result type="..type(mod))
        print(vim.inspect(mod))
      end
    end
  end
end

local function StartDebug()
  check_cwd_for_launch_lua()
  dap.continue()
end

--Key bindings---
vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<CR>', {desc="Toggle Breakpoint"})
vim.keymap.set('n', '<leader>dr', StartDebug, {desc="Start/Continue debug execution"})
vim.keymap.set('n', '<leader>dx', ':DapTerminate<CR>', {desc="Terminate debugging"})
vim.keymap.set('n', '<F10>', ':DapStepOver<CR>', {desc="Step Over"})
vim.keymap.set('n', '<F11>', ':DapStepInto<CR>', {desc="Step Into"})
vim.keymap.set('n', '<F12>', ':DapStepOut<CR>', {desc="Step Out"})
vim.keymap.set({'n', 'v'}, '<Leader>dh', require('dap.ui.widgets').hover, {desc="DAP: hover"})

vim.keymap.set('n', '<leader>dwe', make_jumper_to(""), {desc="Focus first Non-DAP UI"})
vim.keymap.set('n', '<leader>dws', make_jumper_to("dapui_scopes"), {desc="Focus 'Scopes' in DAP UI"})
vim.keymap.set('n', '<leader>dww', make_jumper_to("dapui_watches"), {desc="Focus 'Watches' in DAP UI"})
vim.keymap.set('n', '<leader>dwb', make_jumper_to("dapui_breakpoints"), {desc="Focus 'Breakpoints' in DAP UI"})
vim.keymap.set('n', '<leader>dwS', make_jumper_to("dapui_stacks"), {desc="Focus 'Stacks' in DAP UI"})
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
