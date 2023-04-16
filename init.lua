vim.cmd.colorscheme("evening")

--misc
vim.opt.compatible = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true

--timeouts
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 200

--tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

--ESC mapping
vim.keymap.set({'i', 'v', 'c'}, 'jk', '<ESC>')

require('xml')
require('mycpp')

--replace-operations
vim.keymap.set('n', ' p' ,  'ci(<C-r>0<ESC>', {desc="Replace current content within () with previously copied content"})--inside parentheses ()
vim.keymap.set('n', ' b' ,  'ci{<C-r>0<ESC>', {desc="Replace current content within {} with previously copied content"})--inside brackets {}
vim.keymap.set('n', ' w' ,  'ciw<C-r>0<ESC>', {desc="Replace current content within current word with previously copied content"})--inside word
vim.keymap.set('n', ' W' ,  'ciW<C-r>0<ESC>', {desc="Replace current content within current Word with previously copied content"})--inside Word


--go to the next camel-case part of the word or to the next word
vim.keymap.set('n', 'gx', '/\\(\\([A-Z0-9]\\)\\@<![A-Z0-9]\\|\\([a-zA-Z0-9]\\)\\@<![a-z]\\)<cr>:nohl<cr>', {desc="jump to the next camel-case word part"})
--go to the previous camel-case part of the word or to the previous word
vim.keymap.set('n', 'gz', '?/\\(\\([A-Z0-9]\\)\\@<![A-Z0-9]\\|\\(\\?<![a-zA-Z0-9]\\)[a-z]\\)<cr>:nohl<cr>', {desc="jump to the previous camel-case word part"})
--vim magic to work on camel-case parts of the word without additional plugins
--(first looking for the end and then searching for the start)
--vim.keymap.set('o', 'x', ':<c-u>execute "normal! /\\\\C\\\\v[a-z]([a-z])@!\\r:nohlsearch\\r?\\\\v([A-Z0-9])@<![A-Z0-9]\\\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\\r:nohlsearch\\rv``"<cr>')
--vim.keymap.set('o', 'x', [[:<c-u>execute "normal! /\\C\\v[a-z]([a-z])@!\r:nohlsearch\r?\\v([A-Z0-9])@<![A-Z0-9]\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\r:nohlsearch\rv``"<cr>]])
vim.cmd([[ omap x :<c-u>execute "normal! /\\C\\v[a-z]([a-z])@!\r:nohlsearch\r?\\v([A-Z0-9])@<![A-Z0-9]\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\r:nohlsearch\rv``"<cr> ]])
--this version firt finds start and then searches for the end
--omap x :<c-u>execute 'normal! ?\\v([A-Z0-9])@<![A-Z0-9]\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\r:nohlsearch\r/\\C\\v[a-z]([a-z])@!\r:nohlsearch\rv``'<cr>
--CamelCaseTest

--make current inner word upper case
vim.keymap.set('n', ' u', 'gUiw', {desc="makes current word upper-case"})

--apply format-columns onto the selection
--format in columns for {} blocks (for enums usually)
vim.keymap.set('v', ' ob', ':!format-columns.exe -sep ",}" -ignore "//"<cr>')
--format in columns for () blocks (for functions/methods)
vim.keymap.set('v', ' of', ':!format-columns.exe -sep ",)" -ignore "//" -depthcfg "(1"<cr>')
