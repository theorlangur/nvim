local opts_sources = {cwd="source"}
local opts_resources = {cwd="resource"}
local find_files = require('telescope.builtin').find_files
local find_sources = function() return find_files(opts_sources) end
local find_resources = function() return find_files(opts_resources) end
vim.keymap.set('n', '<leader>ss', find_sources, { desc = '[S]earch in [S]ources' })
vim.keymap.set('n', '<leader>sr', find_resources, { desc = '[S]earch in [R]esources' })
