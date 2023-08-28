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

local function ConditionalBreakPoint()
  dap.toggle_breakpoint(vim.fn.input('Breakpoint condition:'), nil, nil)
end

local function LogPoint()
  dap.toggle_breakpoint(nil, nil, vim.fn.input('Enter log message:'))
end

--Key bindings---
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {desc="Toggle [b]reakpoint"})
vim.keymap.set('n', '<leader>dc', ConditionalBreakPoint, {desc="Toggle [c]onditional Breakpoint"})
vim.keymap.set('n', '<leader>dl', LogPoint, {desc="Toggle [l]og Point"})
vim.keymap.set('n', '<leader>dr', StartDebug, {desc="Start/Continue debug execution"})
vim.keymap.set('n', '<leader>dR', dap.run_to_cursor, {desc="[R]un to cursor"})
vim.keymap.set('n', '<leader>dx', dap.terminate, {desc="Terminate debugging"})
vim.keymap.set('n', '<F10>', dap.step_over, {desc="Step Over"})
vim.keymap.set('n', '<F11>', dap.step_into, {desc="Step Into"})
vim.keymap.set('n', '<F12>', dap.step_out, {desc="Step Out"})
vim.keymap.set({'n', 'v'}, '<Leader>dh', require('dap.ui.widgets').hover, {desc="DAP: hover"})

vim.keymap.set('n', '<leader>dwf', dap.focus_frame, {desc="Focus current frame"})
vim.keymap.set('n', '<leader>dwe', make_jumper_to(""), {desc="Focus first Non-DAP UI"})
vim.keymap.set('n', '<leader>dws', make_jumper_to("dapui_scopes"), {desc="Focus 'Scopes' in DAP UI"})
vim.keymap.set('n', '<leader>dww', make_jumper_to("dapui_watches"), {desc="Focus 'Watches' in DAP UI"})
vim.keymap.set('n', '<leader>dwb', make_jumper_to("dapui_breakpoints"), {desc="Focus 'Breakpoints' in DAP UI"})
vim.keymap.set('n', '<leader>dwS', make_jumper_to("dapui_stacks"), {desc="Focus 'Stacks' in DAP UI"})
vim.keymap.set('n', '<leader>dwr', make_jumper_to("dap-repl"), {desc="Focus 'REPL' in DAP UI"})
--End of key bindings---
--Sign definitions----
--local namespace = vim.api.nvim_create_namespace("dap-hlng")
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg='#993939', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { fg='#61afef', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { fg='#98c379', bg='#31353f' })

vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='❓', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📋', texthl='DapLogPoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='○', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='▶️', texthl='DapStopped', linehl='DapStopped', numhl=''})
--End of sign definitions---

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
