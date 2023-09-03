return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function ()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local tree_api = require('nvim-tree.api')

    local function nvim_tree_edit_or_open()
      local node = tree_api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
        -- expand or collapse folder
        tree_api.node.open.edit()
      else
        -- open file
        tree_api.node.open.edit()
        -- Close the tree if file was opened
        tree_api.tree.close()
      end
    end
    -- open as vsplit on current node
    local function vsplit_preview()
      local node = tree_api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
        -- expand or collapse folder
        tree_api.node.open.edit()
      else
        -- open file as vsplit
        tree_api.node.open.vertical()
      end

      -- Finally refocus on tree if it was lost
      tree_api.tree.focus()
    end

    require('nvim-tree').setup({
      on_attach = function(bufnr)
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        tree_api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set('n', 'l', nvim_tree_edit_or_open, opts('Toggle Folder node/open file'))
        vim.keymap.set('n', 'h', tree_api.node.navigate.parent_close, opts('Close Folder node'))
        vim.keymap.set('n', 'L', vsplit_preview, opts('Open file in a v-split'))
      end
    })
    vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<cr>', { silent=true, noremap=true, desc = 'Show/Hide [F]iles tree' })
  end
}
