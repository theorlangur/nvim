return {
    "sontungexpt/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
        local status_ok, url_open = pcall(require, "url-open")
        if not status_ok then
            return
        end
        url_open.setup ({
          open_app = "!",
          open_only_when_cursor_on_url = true,
          extra_patterns = {
            {
              pattern = '#(%d+)',
              prefix = "https://grandma3.wbb.malighting.de/issues/",
              suffix = "",
            },
            {
              pattern = 'issue=(%d+)',
              prefix = "https://grandma3.wbb.malighting.de/issues/",
              suffix = "",
            }
          }
        })
      vim.keymap.set('n', '<leader>gx', ':URLOpenUnderCursor<cr>', { desc = "Open issue in RedMine" })
    end,
}
