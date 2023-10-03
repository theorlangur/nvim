return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {{'filename', path=1}},
        lualine_x = {'vim.b.current_function', 'encoding', 'fileformat', 'filetype'},
      }
    },
  }
