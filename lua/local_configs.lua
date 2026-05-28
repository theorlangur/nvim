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

local restart_count = 0
local last_restart = 0

local function should_restart()
  local now = vim.loop.now()
  if now - last_restart > 30000 then restart_count = 0 end
  last_restart = now
  restart_count = restart_count + 1
  if restart_count > 5 then
    vim.notify('clangd crashed repeatedly; not restarting', vim.log.levels.WARN)
    return false
  end
  return true
end

vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= 'clangd' then return end

    -- Defer so the dying client is fully gone before we restart
    vim.defer_fn(function()
      local cfg = vim.lsp.config['clangd']
      if should_restart() then
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local ft = vim.bo[buf].filetype
          if vim.api.nvim_buf_is_loaded(buf) and (ft == 'c' or ft == 'cpp' or ft == 'objc') then
            vim.lsp.start(cfg, { bufnr = buf })
          end
        end
      end
    end, 1000)
  end,
})
