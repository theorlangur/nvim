return {
  "chrisgrieser/nvim-various-textobjs",
  event = {"BufReadPost", "BufNewFile"},
  config = function ()
    local to = require('various-textobjs')
    to.setup({ useDefaultKeymaps = false })

    local function wrap(f, arg)
      local _f = to[f]
      return function() _f(arg) end
    end

    local keymap = vim.keymap.set
    keymap({ "o", "x" }, "x", wrap('subword', 'inner'), {desc="Inner subword"})
    keymap({ "o", "x" }, "in", wrap('number', 'inner'), {desc="Inner number"})
    keymap({ "o", "x" }, "ik", wrap('key', 'inner'), {desc="Inner key"})
    keymap({ "o", "x" }, "iv", wrap('value', 'inner'), {desc="Inner value"})
    keymap({ "o", "x" }, "im", wrap('chainMember', 'inner'), {desc="Inner chain member call"})
  end
}
