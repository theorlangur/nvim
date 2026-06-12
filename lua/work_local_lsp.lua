local function switch_source_header(bufnr, client)
  local method_name = 'textDocument/switchSourceHeader'
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info(bufnr, client)
  local method_name = 'textDocument/symbolInfo'
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is no reason to parse it
      return
    end
    local container = string.format('container: %s', res[1].containerName) ---@type string
    local name = string.format('name: %s', res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      title = 'Symbol Info',
    })
  end, bufnr)
end

local function config_lsp(caps, default_on_attach)
  local rust_path = "rust-analyzer"
  -- local clangd_path = "c:\\Work\\tools\\cppindexer\\indexerrepos\\llvm-project\\buildwin_msvc_jul2025\\RelWithDebInfo\\bin\\clangd.exe"
  -- local clangd_path = "c:\\Work\\tools\\cppindexer\\indexerrepos\\llvm-project\\buildwin_clang_lto\\RelWithDebInfo\\bin\\clangd.exe"
  -- local clangd_path = "c:\\Work\\tools\\cppindexer\\indexerrepos\\llvm-project\\buildwin_msvc_jul2025\\RelWithDebInfo\\bin\\clangd.exe"
  -- local clangd_path = "c:\\Work\\tools\\cppindexer\\indexerrepos\\llvm-project\\buildwin_clang_lto\\Release\\bin\\clangd.exe"
  local clangd_path = "c:\\Work\\tools\\cppindexer\\clangd.jul2025.win.clang.native\\bin\\clangd.exe"

  local lua_ls_path = vim.loop.os_homedir().."/AppData/Local/nvim-data/lua-language-server/bin/lua-language-server.exe"



  --[[
  require('lspconfig').clangd.setup {
    capabilities = caps,
    on_attach = default_on_attach,
    cmd={
      "c:\\Work\\tools\\cppindexer\\indexerrepos\\llvm-project\\buildwin_msvc2\\Debug\\bin\\clangd.exe",
      "--background-index",
      "--header-insertion=never",
      "--cache-dir=clangpch",
      "--pch-storage=memory",
      "-j=8",
    }
  }
  ]]

  vim.lsp.config('clangd', {
    capabilities = caps,
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
        switch_source_header(bufnr, client)
      end, { desc = 'Switch between source/header' })

      vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
        symbol_info(bufnr, client)
      end, { desc = 'Show symbol info' })

      default_on_attach(client, bufnr)
    end,
    cmd={
      clangd_path,
      "--background-index",
      "--header-insertion=never",
      "--cache-dir=clang_nvim",
      "--pch-storage=memory",
      "--workspace-symbol-fuzzy-sw",
      "--workspace-symbol-fuzzy-sw",
      "--workspace-symbol-first-space-split-scope-name",
      "--workspace-symbol-extended-queries",
      "-j=24",
      -- "--compile-commands-dir=c:\\Work\\g3\\main\\gma3\\obj\\windows",
      "--compile-commands-dir="..vim.fn.getcwd().."\\obj\\windows",
    }
  })
  CLANGD_CACHE_DIR = vim.fn.getcwd().."\\obj\\windows\\.cache\\"..'clang_nvim'

  vim.lsp.config('rust_analyzer', {
    capabilities = caps,
    on_attach = default_on_attach,
    cmd = {rust_path}
  })

  vim.lsp.config('lua_ls', {
    capabilities = caps,
    on_attach = default_on_attach,
    cmd={lua_ls_path},
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false
        }
      }
    }
  })
end
return config_lsp
