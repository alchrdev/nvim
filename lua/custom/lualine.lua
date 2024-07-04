local custom_theme = require('lualine.themes.tokyonight')

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

require('lualine').setup({
  options = {
    theme = custom_theme,
    globalstatus = true,
    icons_enabled = true,
    section_separators = '',
    component_separators = '',
    disabled_filetypes = {
      statusline = {
        'help',
        'neo-tree',
        'qf',
      },
      winbar = {},
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      { 'b:gitsigns_head', icon = '' }
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = '  ',
          -- readonly = '',
          -- unnamed = '',
        },
      },
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
      },

    },
    lualine_x = {
      'searchcount',
      { 'diff', source = diff_source },
    },
    lualine_y = { 'progress'},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { 'neo-tree', 'lazy' },
})
