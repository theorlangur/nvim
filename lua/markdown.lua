--markup only mappings
function MarkupMappings(args)
    vim.keymap.set('n', '<Space>h1', 'I# <ESC>', {desc="Make level 1 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>h2', 'I## <ESC>', {desc="Make level 2 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>h3', 'I### <ESC>', {desc="Make level 3 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>h4', 'I#### <ESC>', {desc="Make level 4 header", buffer= args.buf})
    vim.keymap.set('n', '<Space>w', 'ebi`<ESC>lea`<ESC>', {desc="Enclose [w]ord in``", buffer= args.buf})
    vim.keymap.set('n', '<Space>W', 'EBi`<ESC>lEa`<ESC>', {desc="Enclose [w]ord in``", buffer= args.buf})
    vim.keymap.set('v', '<Space>m', '<ESC>\'<O```<ESC>\'>o```<ESC>', {desc="Enclose visual block in```", buffer= args.buf})
    vim.keymap.set('v', '<Space>w', '<ESC>`<i`<ESC>`>la`<ESC>', {desc="Enclose visual selection in``", buffer= args.buf})
    vim.keymap.set('v', '<Space>b', '<ESC>`>a**<ESC>`<i**<ESC>', {desc="Make visual selection bold", buffer= args.buf})
    vim.keymap.set('v', '<Space>i', '<ESC>`>a*<ESC>`<i*<ESC>', {desc="Make visual selection italic", buffer= args.buf})
    vim.keymap.set('n', '<Space>j', ':Telescope heading<CR>', {desc="[J]ump to heading", buffer= args.buf})
    vim.keymap.set('v', '<Space>l', '<ESC>`<i[<ESC>`>la](<ESC>"+pa)<ESC>', {desc="Make visual selection into a link from clipboard", buffer= args.buf})

    vim.g.nvim_config_path = vim.fn.stdpath('config')
    vim.api.nvim_command([[
        command! -nargs=* ToPDF silent
        let pandoc_cmd = '!pandoc --from=gfm --to=pdf --resource-path=' . shellescape(g:nvim_config_path) . '/pandoc -H listing.tex --listings -V geometry:margin=.5in -o %:r.pdf %'
        if <q-args> != ''
            let pandoc_cmd .= ' ' . <q-args>
        endif
        execute pandoc_cmd
        ]])
    vim.api.nvim_command([[
        command! -nargs=* ToDoc silent
        let pandoc_cmd = '!pandoc --from=gfm --to=docx --resource-path=' . shellescape(g:nvim_config_path) . '/pandoc -H listing.tex --listings -V geometry:margin=.5in -o %:r.docx %'
        if <q-args> != ''
            let pandoc_cmd .= ' ' . <q-args>
        endif
        execute pandoc_cmd
        ]])
end
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern={"*.md"}, callback=MarkupMappings })
