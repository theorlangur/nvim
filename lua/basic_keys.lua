
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

--ESC mapping
vim.keymap.set({'i', 'v', 'c'}, 'jk', '<ESC>')
vim.keymap.set({'t'}, 'jk', '<C-\\><C-n>', {noremap=true})

--Window management
vim.keymap.set('n', '<A-h>' ,  '<C-w><', {desc="reduce window width"})
vim.keymap.set('n', '<A-l>' ,  '<C-w>>', {desc="increase window width"})
vim.keymap.set('n', '<A-j>' ,  '<C-w>+', {desc="increase window height"})
vim.keymap.set('n', '<A-k>' ,  '<C-w>-', {desc="reduce window height"})

--Tab management
vim.keymap.set('n', '<leader>pa' ,  '<cmd>$tab split<cr>', {desc="Tab [p]age [a]ppend"})
vim.keymap.set('n', '<leader>pc' ,  '<cmd>tabclose<cr>', {desc="Tab [p]age [c]lose"})
vim.keymap.set('n', '<leader>po' ,  '<cmd>tabonly<cr>', {desc="Tab [p]age [o]nly"})
vim.keymap.set('n', '<leader>p1' ,  '1gt', {desc="Goto tab [p]age [1]"})
vim.keymap.set('n', '<leader>p2' ,  '2gt', {desc="Goto tab [p]age [2]"})
vim.keymap.set('n', '<leader>p3' ,  '3gt', {desc="Goto tab [p]age [3]"})
vim.keymap.set('n', '<leader>p4' ,  '4gt', {desc="Goto tab [p]age [4]"})

--jump to previous file
vim.keymap.set('n', 'zf' ,  '<C-^>', {desc="Jump to previous [F]ile"})

--enter visual block ode
vim.keymap.set('n', '<leader>[' ,  '<C-v>', {desc="Enter visual block mode"})
vim.keymap.set({'n', 'v'}, '<leader>na' ,  '<C-a>', {desc="Increment"})
vim.keymap.set({'n', 'v'}, '<leader>nx' ,  '<C-x>', {desc="Decrement"})
vim.keymap.set('v', '<leader>nga' ,  'g<C-a>', {desc="Increment sequence"})
vim.keymap.set('v', '<leader>ngx' ,  'g<C-x>', {desc="Decrement sequence"})

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
