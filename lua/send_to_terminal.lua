local M = {
}

local new_line = '\n'
local shell = nil
if vim.loop.os_uname().version:find('Windows') then
  new_line = '\r'..new_line
  shell = "cmd.exe"
else
  shell = "sh"
end

local function get_term_channel()
  local term_bufnr = vim.fn.bufnr('^term://')
  if term_bufnr == -1 then
    vim.cmd('belowright 10split term://'..shell)
    term_bufnr = vim.fn.bufnr('^term://')
    vim.cmd('normal G')--lock to the end
  end
  return vim.bo[term_bufnr].channel
end

function M.send_term(cmd)
  vim.fn.chansend(get_term_channel(), cmd..new_line)
end

return M
