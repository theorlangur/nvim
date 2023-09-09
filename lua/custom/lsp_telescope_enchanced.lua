local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local sorters = require "telescope.sorters"
local make_entry = require "telescope.make_entry"
local actions_state = require "telescope.actions.state"
local utils = require "telescope.utils"
local channel = require("plenary.async.control").channel
--local entry_display = require "telescope.pickers.entry_display"
--local action_state = require "telescope.actions.state"

local lsp = {}

local symbols_sorter = function(symbols)
  if vim.tbl_isempty(symbols) then
    return symbols
  end

  local current_buf = vim.api.nvim_get_current_buf()

  -- sort adequately for workspace symbols
  local filename_to_bufnr = {}
  for _, symbol in ipairs(symbols) do
    if filename_to_bufnr[symbol.filename] == nil then
      filename_to_bufnr[symbol.filename] = vim.uri_to_bufnr(vim.uri_from_fname(symbol.filename))
    end
    symbol.bufnr = filename_to_bufnr[symbol.filename]
  end

  table.sort(symbols, function(a, b)
    if a.bufnr == b.bufnr then
      return a.lnum < b.lnum
    end
    if a.bufnr == current_buf then
      return true
    end
    if b.bufnr == current_buf then
      return false
    end
    return a.bufnr < b.bufnr
  end)

  return symbols
end

local function get_workspace_symbols_requester(bufnr, opts)
  local cancel = function() end

  return function(prompt)
    local tx, rx = channel.oneshot()
    cancel()
    _, cancel = vim.lsp.buf_request(bufnr, "workspace/symbol", { query = prompt }, tx)

    -- Handle 0.5 / 0.5.1 handler situation
    local err, res = rx()
    assert(not err, err)
    opts.temp.sym_types = {}
    opts.temp.sym_types_sorted = nil

    local locations = vim.lsp.util.symbols_to_items(res or {}, bufnr) or {}
    if not vim.tbl_isempty(locations) then
      locations = utils.filter_symbols(locations, opts, symbols_sorter) or {}
    end
    return locations
  end
end

local function analyze_prompt_title(prompt_bufnr, opts)
  local win_bufnr = prompt_bufnr + 1
  local zeroline = vim.api.nvim_buf_get_lines(win_bufnr, 0, 1, false)[1]
  local l = vim.fn.strcharlen(zeroline)
  opts.temp.h_fill = vim.fn.strcharpart(zeroline, l - 2, 1)
end

local function update_prompt_title(prompt_bufnr, opts, val)
  val = val or ""
  local win_bufnr = prompt_bufnr + 1
  local zeroline = vim.api.nvim_buf_get_lines(win_bufnr, 0, 1, false)[1]
  local l = vim.fn.strcharlen(zeroline)
  local val_l = vim.fn.strcharlen(val)
  local prev_l = opts.temp.prev_l
  if prev_l and prev_l > val_l then
    --must reset the diff
    local _begin = vim.fn.strcharpart(zeroline, 0, l - prev_l - 1)
    local _end = vim.fn.strcharpart(zeroline, l - val_l - 1)
    local reps = string.rep(opts.temp.h_fill, prev_l - val_l)
    zeroline = _begin..reps.._end
  end
  opts.temp.prev_l = val_l
  zeroline = vim.fn.strcharpart(zeroline, 0, l - val_l - 1)..val..vim.fn.strcharpart(zeroline, l - 1)
  vim.api.nvim_buf_set_lines(win_bufnr, 0, 1, false, {zeroline})
end

local function toggle_through_symbol_filter(prompt_bufnr, opts)
  if opts.temp.sym_types_sorted == nil then
    local toggle_array = {}
    for k,v in pairs(opts.temp.sym_types) do
      toggle_array[#toggle_array + 1] = k
    end
    table.sort(toggle_array)
    table.insert(toggle_array, 1, '')
    opts.temp.sym_types_sorted = toggle_array
    opts.temp.selected_sym_index = 1
    for i=2,#toggle_array,1 do
      if toggle_array[i] == opts.temp.selected_sym then
        opts.temp.selected_sym_index = i
        break;
      end
    end
  end
  local s = opts.temp.selected_sym_index
  local l = #opts.temp.sym_types_sorted
  s = (s + 1) % (l + 1)
  opts.temp.selected_sym_index = s
  opts.temp.selected_sym = opts.temp.sym_types_sorted[s]
  update_prompt_title(prompt_bufnr, opts, opts.temp.selected_sym)
  actions_state.get_current_picker(prompt_bufnr):refresh()
end

lsp.dynamic_workspace_symbols = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  opts.winnr = opts.winnr or vim.api.nvim_get_current_win()
  opts.temp = {selected_sym='', sym_types={}}
  local real_entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts)
  local sym_type_collector = function(entry)
    local symbol_msg = entry.text
    local symbol_type = symbol_msg:match "%[(.+)%]%s+.*"
    opts.temp.sym_types[symbol_type] = true;
    return real_entry_maker(entry)
  end

  local filtering_sorter = sorters.highlighter_only(opts)
  filtering_sorter.filter_function = function(_, prompt, entry)
    local sym_type = entry.ordinal:match "%s+([^%s]+)$"
    local selected_sym = opts.temp.selected_sym
    if (not selected_sym) or (selected_sym == '') or (selected_sym == sym_type) then
      return 1, prompt
    end
    return -1, prompt
  end

  pickers
    .new(opts, {
      prompt_title = "LSP Dynamic Workspace Symbols Ex",
      finder = finders.new_dynamic {
        entry_maker = sym_type_collector, --opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
        fn = get_workspace_symbols_requester(opts.bufnr, opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = filtering_sorter,
      attach_mappings = function(prompt_bufnr, map)
        analyze_prompt_title(prompt_bufnr, opts)
        map("i", "<c-l>", function() toggle_through_symbol_filter(prompt_bufnr, opts) end)
        return true
      end,
    })
    :find()
end
return lsp
