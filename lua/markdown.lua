--markup only mappings
function MarkupMappings(args)
    vim.keymap.set('n', '<Space>h1', 'I# <ESC>', {desc="Make level 1 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>h2', 'I## <ESC>', {desc="Make level 2 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>h3', 'I### <ESC>', {desc="Make level 3 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>w', 'ebi`<ESC>lea`<ESC>', {desc="Enclose [w]ord in``", buffer= args.buf})
    vim.keymap.set('n', '<Space>W', 'EBi`<ESC>lEa`<ESC>', {desc="Enclose [w]ord in``", buffer= args.buf})
    vim.keymap.set('v', '<Space>m', '<ESC>\'<O```<ESC>\'>o```<ESC>', {desc="Enclose visual block in```", buffer= args.buf})
    vim.keymap.set('v', '<Space>w', '<ESC>`<i`<ESC>`>la`<ESC>', {desc="Enclose visual selection in``", buffer= args.buf})
end
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern={"*.md"}, callback=MarkupMappings })
