set nocompatible
set number
set relativenumber
set incsearch
set smartcase
set ignorecase
colorscheme evening
set timeout timeoutlen=300 ttimeoutlen=200
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab

imap jk <ESC>
vmap jk <ESC>
cmap jk <ESC>
nnoremap <Space>vb <c-v>

"add a nice header surrounded with /** ... **/
let @h='o/70a*a/o/70a*a/O/*68a a*/68hR'
nnoremap <Space>h yiwO<ESC>@h<C-r>0<ESC>

"replace-operations
nnoremap <Space>( ci(<C-r>0<ESC>
nnoremap <Space>p ci(<C-r>0<ESC>
nnoremap <Space>) ca)<C-r>0<ESC>
nnoremap <Space>[ ci[<C-r>0<ESC>
nnoremap <Space>] ca]<C-r>0<ESC>
nnoremap <Space>{ ci{<C-r>0<ESC>
nnoremap <Space>b ci{<C-r>0<ESC>
nnoremap <Space>} ca}<C-r>0<ESC>
nnoremap <Space>< ci<<C-r>0<ESC>
nnoremap <Space>> ca><C-r>0<ESC>
nnoremap <Space>w ciw<C-r>0<ESC>
nnoremap <Space>W ciW<C-r>0<ESC>
nnoremap <Space>" ci"<C-r>0<ESC>
nnoremap <Space>' ci'<C-r>0<ESC>
nnoremap <Space>l cc<C-r>0<ESC>==

"C++ related stuff
nnoremap <Space>sc astatic_cast<><ESC>
nnoremap <Space>dc adynamic_cast<><ESC>
nnoremap <Space>rc areinterpret_cast<><ESC>
nnoremap <Space>v ivirtual <ESC>
nnoremap <Space>o aoverride<ESC>
nnoremap <Space>ibc iBaseClass::
nnoremap <Space>abc aBaseClass::
nnoremap <Space>cs aconst String &
"delete argument. this works only in VsVim, not in real Vim. Real Vim requires \\|
nnoremap <Space>f i()<ESC>i

"paste from system clipboard
nnoremap <Space>c "*p

"BaseClass::<MethodName>()
nnoremap <Space>i mi?::.*(<CR>2lyt('ipbiBaseClass::<ESC>ea();<ESC>==$hi

"instead of @b for braces - gb (easier to reach)
nnoremap gb @b

"instead of @c for commentint out - gc (easier to reach)
nnoremap gc @c

"instead of @p for parentheses - gp (easier to reach)
nnoremap gp @p

"<Space>s to save file
nnoremap <Space>s :w<CR>

"<Space>xc to comment current xml line out
"nnoremap <Space>xc I<!--<ESC>A--><ESC>    <-- this doesn't work because of the visual studio autocompletion interference
"this works, because initial <!-- is inserted backwards to fool the autocompletion system
nnoremap <Space>xc I-<ESC>i-<ESC>i!<ESC>i<<ESC>A--><ESC>

"<Space>xu to un-comment current xml line
nnoremap <Space>xu ^d4l$d3h

"selection exchange functionality
"mark as selection1
vnoremap <Space>f "yy`<mh`>mj
"exchange current selection with previously marked selection
vnoremap <Space>j <ESC>`>mz`<v`>h"yp`hv`jp`z

"define property
nnoremap <Space>dp yiWBidecltype(<ESC>Ea) <ESC>pa;<ESC>==

"delete function/method
nnoremap <Space>df dd0f{da{<ESC>

"go to the next camel-case part of the word or to the next word
nmap gx /\(\([A-Z0-9]\)\@<![A-Z0-9]\|\([a-zA-Z0-9]\)\@<![a-z]\)<cr>
"go to the previous camel-case part of the word or to the previous word
nmap gz ?/\(\([A-Z0-9]\)\@<![A-Z0-9]\|\(\?<![a-zA-Z0-9]\)[a-z]\)<cr>
"vim magic to work on camel-case parts of the word without additional plugins
"(first looking for the end and then searching for the start)
omap x :<c-u>execute "normal! /\\C\\v[a-z]([a-z])@!\r:nohlsearch\r?\\v([A-Z0-9])@<![A-Z0-9]\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\r:nohlsearch\rv``"<cr>
"this version firt finds start and then searches for the end
"omap x :<c-u>execute 'normal! ?\\v([A-Z0-9])@<![A-Z0-9]\\|([a-zA-Z0-9])@<![a-zA-Z0-9]\r:nohlsearch\r/\\C\\v[a-z]([a-z])@!\r:nohlsearch\rv``'<cr>
"SomeCamelCase 

"make current inner word upper case
nnoremap <Space>u gUiw

"apply format-columns onto the selection
"format in columns for {} blocks (for enums usually)
vnoremap <Space>ob :!format-columns.exe -sep ",}" -ignore "//"<cr>
"format in columns for () blocks (for functions/methods)
vnoremap <Space>of :!format-columns.exe -sep ",)" -ignore "//" -depthcfg "(1"<cr>
