return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  event = {"BufReadPost", "BufNewFile"},
  cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  dependencies = {
    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
  config = function()
    -- [[ Configure LSP ]]
    --  This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      -- NOTE: Remember that lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself
      -- many times.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
      nmap('gt', vim.lsp.buf.type_definition, 'Type [D]efinition')

      local telescope_lsp_doc_sym = require('telescope.builtin').lsp_document_symbols;
      nmap('<leader>ds', function() telescope_lsp_doc_sym({ symbol_width=50, symbol_type_width=8 }); end, '[D]ocument [S]ymbols')

      --nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
      nmap('<leader>ws', require('custom.lsp_telescope_enchanced').dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      nmap('<leader>gd', ':vsplit | lua vim.lsp.buf.definition()<cr>', '[v]split [G]oto [D]efinition')
      nmap('<leader>gD', ':vsplit | lua vim.lsp.buf.declaration()<cr>', '[v]split [G]oto [D]eclaration')
      nmap('<leader>gt', ':vsplit | lua vim.lsp.buf.type_definition()<cr>', '[v]split [G]oto [T]ype')
      --nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      --nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      --nmap('<leader>wl', function()
      --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      --end, '[W]orkspace [L]ist Folders')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
    end

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local is_win = vim.loop.os_uname().version:find('Windows')
    if is_win then
      local original_uri_from_bufnr = vim.uri_from_bufnr
      vim.uri_from_bufnr = function(...)
        local r = original_uri_from_bufnr(...)
        if r and r:sub(1,8) == "file:///" and r:sub(10,10) == ':' then
          return ("file:///%s:%s"):format(string.lower(r:sub(9,9)), r:sub(11))
        end
        return r
      end
    end

    local nvim_cfg = vim.fn.stdpath 'config'
    local local_lsp_config = nvim_cfg .. '/lua/local_lsp.lua'
    if vim.loop.fs_stat(local_lsp_config) ~= nil then
      local ok, mod = pcall(dofile, local_lsp_config)
      if not ok then
        print("Loading local lsp config from "..local_lsp_config.." has failed")
      elseif type(mod) == "function" then
        mod(require('lspconfig'), capabilities, on_attach)
      else
        print("Loading local lsp config from "..local_lsp_config.." returned unexpected value")
        print("Expected function got "..type(mod))
      end
    end
    --vim.lsp.set_log_level("trace")
  end
}
