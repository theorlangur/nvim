local function delete_other_buffers(prompt_bufnr)
  local bufs = vim.api.nvim_list_bufs()
  for i=1,#bufs,1 do
    local b = bufs[i]
    if b ~= prompt_bufnr and vim.fn.buflisted(b) == 1 then
      vim.print("Deleting b="..tostring(b).."; name="..vim.api.nvim_buf_get_name(b))
      local force = vim.api.nvim_buf_get_option(b, "buftype") == "terminal"
      local ok = pcall(vim.api.nvim_buf_delete, b, { force = force })
    end
  end
  require('telescope.actions').close(prompt_bufnr)
end

return {
  'nvim-telescope/telescope.nvim',
  --branch = '0.1.x',
  branch = 'master',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', },
  },
  config = function ()
    local actions = require('telescope.actions')
    local actions_layout = require('telescope.actions.layout')
    local prints_left = 3
    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      defaults = {
        path_display = {"truncate"},
        mappings = {
          i = {
            ['<esc>'] = actions.close,
            ['<M-p>'] = actions_layout.toggle_preview,
          },
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              ["<c-d>"] = "delete_buffer",
              ["<c-o>"] = delete_other_buffers,
            }
          }
        }
      }
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')

    local tele = require('telescope.builtin')

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', tele.oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', tele.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      tele.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>gf', tele.git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', tele.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sgb', tele.git_branches, { desc = '[S]earch [G]it [B]ranches' })
    vim.keymap.set('n', '<leader>sw', tele.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sgg', tele.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', tele.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('v', '<leader>svv', '"zy<ESC><cmd>exec \'Telescope live_grep default_text=\'.escape(@z, \' \')<CR>', { desc = '[S]earch [V]isual selection'})
  end
}
