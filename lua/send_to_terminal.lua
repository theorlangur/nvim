local M = {
}

local function get_term_channel()
  local term_bufnr = vim.fn.bufnr('^term://')
  if term_bufnr == -1 then
    vim.cmd('belowright 10split term://cmd.exe')
    term_bufnr = vim.fn.bufnr('^term://')
  end
  return vim.bo[term_bufnr].channel
end

function M.send_term(cmd)
  vim.fn.chansend(get_term_channel(), cmd.."\r\n")
end

return M
