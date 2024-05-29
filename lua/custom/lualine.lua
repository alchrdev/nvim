local custom_theme = require("lualine.themes.catppuccin")

-- Make statusbar transparent
for _, mode in pairs(custom_theme) do
  for section_name, section in pairs(mode) do
    if section_name ~= "a" then
      section.bg = "none"
    end
  end
end

require("lualine").setup({
  options = {
    theme = custom_theme,
    globalstatus = true,
    icons_enabled = true,
    section_separators = "",
    component_separators = "",
    disabled_filetypes = {
      statusline = {
        "help",
        "neo-tree",
        "qf",
      },
      winbar = {},
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      "fancy_branch",
    },
    lualine_c = {
      {
        "filename",
        path = 1,
        symbols = {
          modified = "  ",
          -- readonly = "",
          -- unnamed = "",
        },
      },

      {
        "fancy_diagnostics",
        sources = { "nvim_lsp" },
        symbols = { error = " ", warn = " ", info = " " },
      },
      { "fancy_searchcount" },
    },
    lualine_x = {
      "fancy_diff",
      "progress",
    },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "neo-tree", "lazy" },
})
