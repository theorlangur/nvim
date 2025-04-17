-- Lua code to add to your Neovim configuration (e.g., init.lua or a dedicated file in your lua/ directory)
local function copy_filename_with_line_number()
  -- Get the current file name
  local filename = vim.api.nvim_buf_get_name(0)

  -- Get the current line number
  local line_number = vim.api.nvim_win_get_cursor(0)[1]

  local relative_filename = vim.fn.expand("%")

  -- Combine the filename and line number
  local text_to_copy = string.format("%s:%d", relative_filename, line_number)

  -- Copy to the system clipboard (using the '+' register)
  vim.fn.setreg('+', text_to_copy)

  -- Optional: Provide a visual feedback
  vim.notify("Copied: " .. text_to_copy, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>ln', copy_filename_with_line_number, { desc = 'Copy Filename:[l]ine [n]umber' })
