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
--clear register
vim.cmd("let @h=''")

--C++ only mappings
function CppMappings(args)
    --add a nice header surrounded with /** ... **/
    vim.cmd("let @h='o/70a*a/o/70a*a/O/*68a a*/68hR'")
    vim.keymap.set('n', '<Space>h', 'yiwO<ESC>@h<C-r>0<ESC>', {desc="Insert /**...**/ header block", buffer= args.buf})

    --C++ related stuff
    vim.keymap.set('n', ' sc'  , 'astatic_cast<><ESC>', {desc="adds static_cast<>", buffer= args.buf})
    vim.keymap.set('n', ' dc'  , 'adynamic_cast<><ESC>', {desc="adds dynamic_cast<>", buffer= args.buf})
    vim.keymap.set('n', ' rc'  , 'areinterpret_cast<><ESC>', {desc="adds reinterpret_cast<>", buffer= args.buf})
    vim.keymap.set('n', ' v'   , 'ivirtual <ESC>', {desc="inserts 'virtual'", buffer= args.buf})
    vim.keymap.set('n', ' o'   , 'aoverride<ESC>', {desc="appends 'override'", buffer= args.buf})
    vim.keymap.set('n', ' ibc' , 'iBaseClass::', {desc="inserts 'BaseClass::'", buffer= args.buf})
    vim.keymap.set('n', ' abc' , 'aBaseClass::', {desc="appends 'BaseClass::'", buffer= args.buf})

    --BaseClass::<MethodName>()
    vim.keymap.set('n', ' i', 'mi?::.*(<CR>2lyt(\'ipbiBaseClass::<ESC>ea();<ESC>==$hi', {desc="inserts 'BaseClass::<current method name>'", buffer= args.buf})
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern={"*.c", "*.h", "*.cpp", "*.hpp"}, callback=CppMappings })

--replace-operations
vim.keymap.set('n', ' p' ,  'ci(<C-r>0<ESC>', {desc="Replace current content within () with previously copied content"})--inside parentheses ()
vim.keymap.set('n', ' b' ,  'ci{<C-r>0<ESC>', {desc="Replace current content within {} with previously copied content"})--inside brackets {}
vim.keymap.set('n', ' w' ,  'ciw<C-r>0<ESC>', {desc="Replace current content within current word with previously copied content"})--inside word
vim.keymap.set('n', ' W' ,  'ciW<C-r>0<ESC>', {desc="Replace current content within current Word with previously copied content"})--inside Word


--<Space>xc to comment current xml line out
vim.keymap.set('n', ' xc', 'I<!--<ESC>A--><ESC>', {desc="inserts <!-- -->"})

--<Space>xu to un-comment current xml line
vim.keymap.set('n', ' xu', '^d4l$d3h')

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
