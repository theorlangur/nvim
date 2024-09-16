function QuickFixMappings(args)
    vim.keymap.set('n', '<Space>fw', 'yiw:Cfilter <C-r>0<CR>', {desc="Filter in quickfix with word", buffer= args.buf})
    vim.keymap.set('n', '<Space>fW', 'yiw:Cfilter! <C-r>0<CR>', {desc="Filter out quickfix with word ", buffer= args.buf})
end
vim.api.nvim_create_autocmd("FileType", { pattern={"qf"}, callback=QuickFixMappings })
vim.api.nvim_command("packadd cfilter")
