local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local entry_display = require "telescope.pickers.entry_display"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local send_term = require("send_to_terminal").send_term

local M = { tasks = {} }

local task_name_width = 15
local task_name_width_max = 35
local task_displayer = nil

local function update_task_name_width(tasks)
  local r = task_name_width
  for i=1,#tasks,1 do
    local l = tasks[i].name:len() + 2
    if l > r then r = l end
  end
  if r > task_name_width_max then r = task_name_width_max end
  return r
end

local function task_make_display(entry)
  return task_displayer{
    entry.value.name,
    entry.value.description,
  }
end


local function task_entry_maker(entry)
  return {
    value = entry,
    display = task_make_display,
    ordinal = entry.name,
  }
end

local function check_cwd_for_tasks_lua()
  local cwd = vim.loop.cwd()
  local tasks_path = cwd..'/.nvim/tasks.lua'
  if vim.loop.fs_stat(tasks_path) ~= nil then
    --exists
    local ok, mod = pcall(dofile, tasks_path)
    if not ok then
      print("Loading "..tasks_path.." failed")
    else
      print("Loaded "..tasks_path)
      if type(mod) == "table" then
        M.tasks = mod
      else
        print("Unexpected result type="..type(mod))
        print(vim.inspect(mod))
      end
    end
  end
end

local function get_command(value)
  if type(value.cmd) == "string" then
    return value.cmd
  elseif type(value.cmd) == "table" then
    return table.concat(value.cmd, " ")
  elseif type(value.cmd) == "function" then
    return value.cmd()
  end
end

function M.tasks_picker(opts)
  check_cwd_for_tasks_lua()
  task_name_width = update_task_name_width(M.tasks)
  task_displayer = entry_display.create{
    separator = " ",
    items = {
      {width = task_name_width },
      {remaining = true },
    }
  }
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Tasks",
    finder = finders.new_table {
      results = M.tasks,
      entry_maker = task_entry_maker,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          send_term(get_command(selection.value))
        end)
      return true
    end
  }):find()
end

return M
