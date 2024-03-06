local opts_sources = {cwd="source"}
local opts_resources = {cwd="resource"}
local find_files = require('telescope.builtin').find_files
local live_grep = require('telescope.builtin').live_grep
local find_sources = function() return find_files(opts_sources) end
local find_resources = function() return find_files(opts_resources) end
local live_grep_sources = function() return live_grep(opts_sources) end
local live_grep_resources = function() return live_grep(opts_resources) end
vim.keymap.set('n', '<leader>ss', find_sources, { desc = '[S]earch in [S]ources' })
vim.keymap.set('n', '<leader>sr', find_resources, { desc = '[S]earch in [R]esources' })
vim.keymap.set('n', '<leader>sgr', live_grep_resources, { desc = '[S]earch by [G]rep in [R]esources' })
vim.keymap.set('n', '<leader>sgs', live_grep_sources, { desc = '[S]earch by [G]rep in [S]ources' })
