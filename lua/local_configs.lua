local opts_sources = {cwd="source"}
local opts_resources = {cwd="resource"}
local opts_projects = {cwd="projects"}
local find_files = require('telescope.builtin').find_files
local live_grep = require('telescope.builtin').live_grep
local find_sources = function() return find_files(opts_sources) end
local find_resources = function() return find_files(opts_resources) end
local live_grep_sources = function() return live_grep(opts_sources) end
local live_grep_resources = function() return live_grep(opts_resources) end
local find_projects = function() return find_files(opts_projects) end
local live_grep_projects = function() return live_grep(opts_projects) end
vim.keymap.set('n', '<leader>ss', find_sources, { desc = '[S]earch in [S]ources' })
vim.keymap.set('n', '<leader>sr', find_resources, { desc = '[S]earch in [R]esources' })
vim.keymap.set('n', '<leader>sp', find_projects, { desc = '[S]earch in [P]rojects' })
vim.keymap.set('n', '<leader>sgr', live_grep_resources, { desc = '[S]earch by [G]rep in [R]esources' })
vim.keymap.set('n', '<leader>sgs', live_grep_sources, { desc = '[S]earch by [G]rep in [S]ources' })
vim.keymap.set('n', '<leader>sgp', live_grep_projects, { desc = '[S]earch by [G]rep in [P]rojects' })
vim.keymap.set('v', '<leader>svr', '"zy<ESC><cmd>exec \'Telescope live_grep cwd=resource default_text=\'.escape(@z, \' \')<CR>', { desc = '[S]earch [V]isual selection in [R]esources'})
vim.keymap.set('v', '<leader>svs', '"zy<ESC><cmd>exec \'Telescope live_grep cwd=source default_text=\'.escape(@z, \' \')<CR>', { desc = '[S]earch [V]isual selection in [S]ources'})
vim.keymap.set('v', '<leader>svp', '"zy<ESC><cmd>exec \'Telescope live_grep cwd=projects default_text=\'.escape(@z, \' \')<CR>', { desc = '[S]earch [V]isual selection in [P]rojects'})

-- Function to re-attach LSP client to all C++ buffers
local function reattach_cpp_lsp()
  -- Get the list of all buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Iterate over all buffers
  for _, buf in ipairs(buffers) do
    -- Check if the buffer is of type C++
    if vim.bo[buf].filetype == "cpp" then
      -- Check if the buffer is valid and loaded
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
        -- Get the active LSP clients for the buffer
        local clients = vim.lsp.buf_get_clients(buf)
        if next(clients) == nil then
          -- If no active LSP clients, re-attach the LSP server
          vim.lsp.buf_attach_client(buf, vim.lsp.start({
            name = "clangd", -- Change to your desired LSP client (e.g., clangd)
          }))
          print("Re-attached LSP client to buffer " .. buf)
        end
      end
    end
  end
end

-- Add a command to manually trigger the function
vim.api.nvim_create_user_command("ReClangd", reattach_cpp_lsp, {})
