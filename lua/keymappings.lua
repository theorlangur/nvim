--ESC mapping
vim.keymap.set({'i', 'v', 'c'}, 'jk', '<ESC>')

--Window management
vim.keymap.set('n', '<A-h>' ,  '<C-w><', {desc="reduce window width"})
vim.keymap.set('n', '<A-l>' ,  '<C-w>>', {desc="increase window width"})
vim.keymap.set('n', '<A-j>' ,  '<C-w>+', {desc="increase window height"})
vim.keymap.set('n', '<A-k>' ,  '<C-w>-', {desc="reduce window height"})

--Tab management
vim.keymap.set('n', 'gtn' ,  ':tabnext<cr>', {desc="go to next tab"})
vim.keymap.set('n', 'gtp' ,  ':tabprev<cr>', {desc="go to prev tab"})
vim.keymap.set('n', 'gtT' ,  ':tabnew<cr>', {desc="create new tab"})
vim.keymap.set('n', 'gtc' ,  ':tabclose<cr>', {desc="close current tab"})
vim.keymap.set('n', 'gto' ,  ':tabonly<cr>', {desc="close all other tabs"})

--system clipboard mappings
vim.keymap.set({'n', 'v'}, '<leader>y' ,  '"+y', {desc="copy to system clipboard"})
vim.keymap.set({'n', 'v'}, '<leader>p' ,  '"+p', {desc="paste from system clipboard"})


--replace-operations
--vim.keymap.set('n', '<leader>p' ,  'ci(<C-r>0<ESC>', {desc="Replace current content within () with previously copied content"})--inside parentheses ()
vim.keymap.set('n', '<leader>b' ,  'ci{<C-r>0<ESC>', {desc="Replace current content within {} with previously copied content"})--inside brackets {}
vim.keymap.set('n', '<leader>w' ,  'ciw<C-r>0<ESC>', {desc="Replace current content within current word with previously copied content"})--inside word
vim.keymap.set('n', '<leader>W' ,  'ciW<C-r>0<ESC>', {desc="Replace current content within current Word with previously copied content"})--inside Word


--go to the next camel-case part of the word or to the next word
vim.keymap.set('n', 'gx', '/\\(\\([A-Z0-9]\\)\\@<![A-Z0-9]\\|\\([a-zA-Z0-9]\\)\\@<![a-z]\\)<cr>:nohl<cr>', {desc="jump to the next camel-case word part"})
--go to the previous camel-case part of the word or to the previous word
vim.keymap.set('n', 'gz', '?/\\(\\([A-Z0-9]\\)\\@<![A-Z0-9]\\|\\(\\?<![a-zA-Z0-9]\\)[a-z]\\)<cr>:nohl<cr>', {desc="jump to the previous camel-case word part"})
--vim magic to work on camel-case parts of the word without additional plugins
--(first looking for the end and then searching for the start)
vim.cmd([[omap x :<c-u>execute "normal! /\\C\\v[a-z]([a-z])@!\r:nohlsearch\r?\\v([A-Z0-9])@<![A-Z0-9]\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\r:nohlsearch\rv``"<cr>]])

--make current inner word upper case
vim.keymap.set('n', '<leader>u', 'gUiw', {desc="makes current word upper-case"})
vim.keymap.set('n', '<leader>l', 'guiw', {desc="makes current word lower-case"})

--apply format-columns onto the selection
--format in columns for {} blocks (for enums usually)
vim.keymap.set('v', '<leader>ob', ':!format-columns.exe -sep ",}" -ignore "//"<cr>')
--format in columns for () blocks (for functions/methods)
vim.keymap.set('v', '<leader>of', ':!format-columns.exe -sep ",)" -ignore "//" -depthcfg "(1"<cr>')

--AnsiColors
vim.cmd([[
let s:baleia = luaeval("require('baleia').setup {}")
command! AnsiColors call s:baleia.once(bufnr('%'))
]])
