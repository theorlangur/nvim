vim.keymap.set({ 'n' }, '<Space>Ss', ':mksession! .nvim_saved_session<CR>', { desc = "[S]ession [s]ave" })
vim.keymap.set({ 'n' }, '<Space>Sl', ':source .nvim_saved_session<CR>', { desc = "[S]ession [l]oad" })
