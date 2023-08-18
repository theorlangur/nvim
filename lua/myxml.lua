function XmlMappings(args)
    --<Space>xc to comment current xml line out
    vim.keymap.set('n', ' xc', 'I<!--<ESC>A--><ESC>', {desc="inserts <!-- -->", buffer=args.buf})

    --<Space>xu to un-comment current xml line
    vim.keymap.set('n', ' xu', '^d4l$d3h', {desc="Delete <!-- -->", buffer=args.buf})
end

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, { pattern={"*.xml", "*.uixml"}, callback=XmlMappings })

