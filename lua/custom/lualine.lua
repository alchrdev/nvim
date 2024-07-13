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

-- Make statusbar transparent
for _, mode in pairs(custom_theme) do
  for section_name, section in pairs(mode) do
    if section_name ~= "a" then
      section.bg = "none"
    end
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
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      {
        'diagnostics',
        sources = { 'nvim_lsp' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        padding = { right = 1 },
      },
      {'filetype', icon_only = true, separator = '', padding = { left = 2, right = 0 }},
      {
        'filename',
        shorting_target = 20,
        symbols = {
          modified = '*',
          readonly = '[ro]',
          unnamed = 'Untitled',
          newfile = 'New file',
        }
      },
      { "b:gitsigns_head", icon = "" },
      { "diff", source = diff_source },

    },
    lualine_y = {},
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
