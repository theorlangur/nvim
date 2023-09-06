local lsp_proto = require('vim.lsp.protocol')
local scope_kinds = {
 Class = true,
 Function = true,
 Method = true,
 Struct = true,
 Enum = true,
 Interface = true,
 Namespace = true,
 Module = true,
}
local latest_doc_syms = {
    --[bufnr] => {filtered result list}
}
local function extract_symbols(items, _result)
  local result = _result or {}
  if items == nil then return result end
  for _, item in ipairs(items) do
    local kind = lsp_proto.SymbolKind[item.kind] or 'Unknown'
    local sym_range = nil
    if item.location then -- Item is a SymbolInformation
      sym_range = item.location.range
    elseif item.range then -- Item is a DocumentSymbol
      sym_range = item.range
    end

    if sym_range then
      sym_range.start.line = sym_range.start.line + 1
      sym_range['end'].line = sym_range['end'].line + 1
    end

    table.insert(result, {
      filename = item.location and vim.uri_to_fname(item.location.uri) or nil,
      range = sym_range,
      kind = kind,
      text = item.name,
      raw_item = item
    })

    if item.children then
      extract_symbols(item.children, result)
    end
  end

  return result
end

local function in_range(pos, range)
  local line = pos[1]
  local char = pos[2]
  if line < range.start.line or line > range['end'].line then return false end
  if
    line == range.start.line and char < range.start.character or
    line == range['end'].line and char > range['end'].character
  then
    return false
  end

  return true
end

local function filter(list, test)
  local result = {}
  for i, v in ipairs(list) do
    if test(i, v) then
      table.insert(result, v)
    end
  end

  return result
end
local function getRangeSymbolForWin(w, syms)
    local cursor_pos = vim.api.nvim_win_get_cursor(w)
    for i = #syms, 1, -1 do
        local sym = syms[i]
        if sym.range and in_range(cursor_pos, sym.range) then
          return sym.kind.." "..sym.text
        end
    end
    return nil
end
local function docSymHandler(_, result, ctx, _)
    local function_symbols = filter(extract_symbols(result),
    function(_, v)
      return scope_kinds[v.kind]
    end)
    latest_doc_syms[ctx.bufnr] = function_symbols

    if vim.api.nvim_win_get_buf(0) == ctx.bufnr then
        local fn_name = getRangeSymbolForWin(0, function_symbols)
        vim.b.current_function = fn_name
    end
end

local deafult_handler = vim.lsp.handlers['textDocument/documentSymbol'];
vim.lsp.handlers['textDocument/documentSymbol'] = function(_, result, ctx, config)
    docSymHandler(_, result, ctx, config)
    return deafult_handler(_, result, ctx, config)
end

vim.api.nvim_create_autocmd({'TextChanged', 'InsertLeave', 'LspAttach'}, {
    callback = function(ev)
        local bufnr = ev.buf
        local params = {textDocument = vim.lsp.util.make_text_document_params(bufnr)}
        vim.lsp.buf_request(bufnr, 'textDocument/documentSymbol', params, docSymHandler)
    end
})

vim.api.nvim_create_autocmd('CursorMoved', {
    callback = function(ev)
        local bufnr = ev.buf
        local w = vim.api.nvim_get_current_win()
        if vim.api.nvim_win_get_buf(w) == bufnr then
            local function_symbols = latest_doc_syms[bufnr]
            if function_symbols then
                local fn_name = getRangeSymbolForWin(w, function_symbols)
                vim.b.current_function = fn_name
            end
        end
    end
})
