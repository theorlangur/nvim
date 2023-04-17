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

if vim.g.vscode then
    vim.keymap.set('n', 'gl'   , '<Cmd>call VSCodeNotify("editor.action.revealDeclaration")<cr>', {desc="Go to declaration"})
    vim.keymap.set('n', 'gr'   , '<Cmd>call VSCodeNotify("editor.action.goToReferences")<cr>', {desc="Go to references"})
    vim.keymap.set('n', 'gi'   , '<Cmd>call VSCodeNotify("editor.action.goToImplementation")<cr>', {desc="Go to implementations"})
   vim.keymap.set('n', ' k', '<Cmd>call VSCodeNotify("workbench.action.keepEditor")<cr>')
   vim.keymap.set('n', ' ct', '<Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<cr>')
   vim.keymap.set('n', ' co', '<Cmd>call VSCodeNotify("workbench.action.closeOtherEditors")<cr>')
end
