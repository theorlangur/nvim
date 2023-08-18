
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

--ESC mapping
vim.keymap.set({'i', 'v', 'c'}, 'jk', '<ESC>')

--Window management
vim.keymap.set('n', '<A-h>' ,  '<C-w><', {desc="reduce window width"})
vim.keymap.set('n', '<A-l>' ,  '<C-w>>', {desc="increase window width"})
vim.keymap.set('n', '<A-j>' ,  '<C-w>+', {desc="increase window height"})
vim.keymap.set('n', '<A-k>' ,  '<C-w>-', {desc="reduce window height"})


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--make current inner word upper case
vim.keymap.set('n', '<leader>u', 'gUiw', {desc="makes current word upper-case"})
vim.keymap.set('n', '<leader>l', 'guiw', {desc="makes current word lower-case"})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
