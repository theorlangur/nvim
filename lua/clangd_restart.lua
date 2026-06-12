-- ===== clangd restart / crash-recovery =====
local MAX_CRASHES = 5
local CRASH_WINDOW = 20 -- seconds
local crash_times = {}  -- timestamps of recent crashes
local gave_up = false

local function restart_clangd(before_start)
  crash_times = {}
  gave_up = false
  vim.lsp.enable('clangd', false)
  local timer = assert(vim.uv.new_timer())
  timer:start(100, 100, vim.schedule_wrap(function()
    if #vim.lsp.get_clients({ name = 'clangd' }) == 0 then
      timer:stop()
      timer:close()
      if before_start then
        before_start()
      end
      vim.lsp.enable('clangd')
    end
  end))
end

vim.api.nvim_create_user_command('ClangdRestart', restart_clangd, {
  desc = 'Restart clangd and re-attach all C/C++ buffers',
})

vim.api.nvim_create_user_command('ClangdCleanRestart', function(opts)
  local dir = opts.args ~= '' and opts.args or CLANGD_CACHE_DIR
  restart_clangd(function()
    if dir and dir ~= '' then
      local ok, err = pcall(vim.fs.rm, dir, { recursive = true, force = true })
      if ok then
        vim.notify(('deleted %s'):format(dir), vim.log.levels.INFO)
      else
        vim.notify(('failed to delete %s: %s'):format(dir, err), vim.log.levels.ERROR)
      end
    end
  end)
end, {
nargs = '?',
complete = 'dir',
desc = 'Stop clangd, delete cache dir, restart and re-attach buffers',
})

local function on_clangd_exit(code, signal, _client_id)
  if code == 0 and signal == 0 then
    return -- graceful shutdown, not a crash
  end
  if gave_up then
    return
  end

  vim.schedule(function()
    local now = vim.uv.now() / 1000
    -- keep only crashes inside the window
    crash_times = vim.tbl_filter(function(t)
      return now - t < CRASH_WINDOW
    end, crash_times)
    table.insert(crash_times, now)

    if #crash_times >= MAX_CRASHES then
      gave_up = true
      vim.notify(
        ('clangd crashed %d times within %ds — not restarting anymore. ' ..
         'Use :ClangdRestart to try again.'):format(#crash_times, CRASH_WINDOW),
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify(
      ('clangd crashed (code=%d, signal=%d), restarting (%d/%d)')
        :format(code, signal, #crash_times, MAX_CRASHES),
      vim.log.levels.WARN
    )
    -- toggle enable: re-enabling attaches all existing C/C++ buffers
    vim.lsp.enable('clangd', false)
    vim.defer_fn(function()
      vim.lsp.enable('clangd')
    end, 100)
  end)
end

vim.lsp.config('clangd', {
  on_exit = on_clangd_exit,
})
