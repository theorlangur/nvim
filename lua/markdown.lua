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

    local is_windows = vim.fn.has("win32") == 1
    local path_sep = is_windows and "\\" or "/"
    local res_sep = is_windows and ";" or ":"

    vim.g.nvim_config_path = vim.fn.stdpath('config')
    vim.api.nvim_command([[
        command! -nargs=* ToPDF silent
        " Get the current file's directory
        let current_file_dir = expand('%:p:h')

        " Combine the config path and the file directory (using colon as separator)
        let res_paths = shellescape(g:nvim_config_path . '/pandoc]].. res_sep..[[' . current_file_dir)

        let pandoc_cmd = '!pandoc --from=gfm --to=pdf --resource-path=' . res_paths . ' --template=github-style.tex --pdf-engine=xelatex --highlight-style=tango -o %:r.pdf %'
        if <q-args> != ''
            let pandoc_cmd .= ' ' . <q-args>
        endif
        execute pandoc_cmd
        ]])
    vim.api.nvim_command([[
        command! -nargs=* ToDoc silent
        " Get the current file's directory
        let current_file_dir = expand('%:p:h')

        " Combine the config path and the file directory (using colon as separator)
        let res_paths = shellescape(g:nvim_config_path . '/pandoc]].. res_sep..[[' . current_file_dir)

        let pandoc_cmd = '!pandoc  --resource-path=' . res_paths . ' --reference-doc=github-reference.docx --highlight-style=tango -o %:r.docx %'
        if <q-args> != ''
            let pandoc_cmd .= ' ' . <q-args>
        endif
        execute pandoc_cmd
        ]])
end
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern={"*.md"}, callback=MarkupMappings })
