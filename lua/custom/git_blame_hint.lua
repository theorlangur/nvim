local M = {}
local buf_name = 'git_blame_info'

local function get_or_create_info_buf()
  local buf = vim.fn.bufnr(buf_name)
  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, buf_name)
  end
  return buf
end

local function get_or_create_window(buf)
    local line0 = vim.fn.line('w0')
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local relLine = line - line0
    local win_width = vim.api.nvim_win_get_width(0)
    local win_height = vim.api.nvim_win_get_height(0)
    local r = 0
    local h = relLine
    local bcount = vim.api.nvim_buf_line_count(buf)
    local anc = 'SW'
    if h < bcount and h < (win_height - relLine) then
      h = win_height - relLine
      if h > bcount then h = bcount end
      anc = 'NW'
      r = relLine + 1
    elseif h >= bcount then
      h = bcount
      r = relLine
    end
    local opts = {relative='win', width=win_width, height=h, col=0, row=r, anchor=anc, style='minimal', border='rounded'}
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_create_autocmd({"BufLeave"}, {
      buffer = buf,
      callback = function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, {force=true})
      end
    })
    return win
end

local function do_blame_line()
  local currFile = vim.fn.expand('%')
  local line = vim.api.nvim_win_get_cursor(0)
  local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], currFile))
  local hash = vim.split(blame, '%s')[1]
  local cmd = string.format("git show --quiet --format=medium %s ", hash)
  local text = {}
  if hash == '00000000' then
    text = {'Not Committed Yet'}
  else
    text = vim.split(vim.fn.system(cmd), '\n')
    if text[1]:find("fatal") then -- if the call to git show fails
      text = {'Not Committed Yet'}
    end
  end
  return text
end

function M.blame_current_line()
  local blame_text = do_blame_line()
  local b = get_or_create_info_buf()
  vim.api.nvim_buf_set_lines(b, 0, -1, true, blame_text)
  local w = get_or_create_window(b)
end

return M
