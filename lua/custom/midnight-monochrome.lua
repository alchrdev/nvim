require("catppuccin").setup({
  background = {
    light = "latte",
    dark = "mocha",
  },
  color_overrides = {
    mocha = {
      rosewater = "#e4708e",
      flamingo = "#e4708e",
      pink = "#e4708e",
      mauve = "#e4708e",
      red = "#e4708e",
      maroon = "#e4708e",
      peach = "#e4708e",
      yellow = "#efcf9e",
      green = "#8ba7be",
      teal = "#7DAEA9",
      sky = "#dfe0f2",
      sapphire = "#7daea9",
      blue = "#7daea9",
      lavender = "#7daea9",
      text = "#777777",
      subtext1 = "#6e6e6e",
      subtext0 = "#656565",
      overlay2 = "#5c5c5c",
      overlay1 = "#535353",
      overlay0 = "#4a4a4a",
      surface2 = "#414141",
      surface1 = "#383838",
      surface0 = "#2f2f2f",
      base = "#191919",
      mantle = "#262626",
      crust = "#1e1e1e",
    },
  },
  styles = {
    comments = { "italic" },
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  transparent_background = false,
  show_end_of_buffer = false,
  highlight_overrides = {
    all =  function (colors)
      return {
        FloatBorder = { bg = colors.none, fg = colors.surface0},
        VertSplit = { bg = colors.surface0, fg = colors.surface0 },
        WinSeparator = { fg = colors.surface0 },
        CursorLineNr = { fg = colors.surface2 },
        Pmenu = { bg = colors.none },
        PmenuSel = { bg = colors.mantle },
        PmenuThumb = { bg = colors.none },
        PmenuSbar = { bg = colors.none },
        Search = { bg = "#4d1230", fg = colors.text},
        IncSearch = { bg = "#0e3739", fg = colors.text},
        LazyH1 = { bg = colors.mantle},
        HarpoonBorder = { fg = colors.surface0 },
        GitSignsAdd = { fg = "#3a5f5b" },
        GitSignsChange = { fg = "#384e61" },
        GitSignsDelete = { fg = "#7a3232" },
        TelescopeSelection = { fg = colors.text, bg = colors.mantle },
        TelescopeSelectionCaret = { fg = colors.mantle, bg = colors.mantle },
        TelescopePromptPrefix = { fg = colors.surface0 },
        -- Configuration without transparency 
        NormalFloat = {  bg = colors.base  },
        TelescopePromptNormal = { bg = colors.crust },
        TelescopeResultsNormal = { bg = colors.crust },
        TelescopePreviewNormal = { bg = colors.crust},
        TelescopeResultsBorder = { bg = colors.crust, fg = colors.crust },
        TelescopeBorder = { bg = colors.crust },
        TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
        TelescopePromptBorder = { bg = colors.crust, fg = colors.crust },
        TelescopePromptTitle = { fg = colors.crust, bg = colors.crust},
        TelescopeResultsTitle = { fg = colors.crust, bg = colors.crust },

        -- Configuration with transparency 
        -- TelescopeBorder = { fg = colors.mantle},
        -- TelescopePromptTitle = { fg = colors.mantle},
        -- TelescopeResultsTitle = { fg = colors.mantle},
        -- NormalFloat = {  bg = colors.none},


        -- Color groups to highlight syntax and UI elements
        MarkdownHeading = { fg = colors.red },
        TextHighlight = { fg = colors.text },
        LinkText = { fg = colors.teal },
        UrlText = { fg = colors.sky },

        -- General Purpose Color Group Associations
        ["@markup.heading.1.markdown"] = { link = "MarkdownHeading" },
        ["@markup.heading.4.markdown"] = { link = "MarkdownHeading" },
        ["@markup.heading.5.markdown"] = { link = "MarkdownHeading" },
        ["@markup.heading.6.markdown"] = { link = "MarkdownHeading" },
        ["@markup.link"] = { link = "LinkText" },
        ["@markup.link.url"] = { link = "UrlText" },
        ["@markup.quote"] = { link = "TextHighlight" },
      }
    end
  },
})

vim.api.nvim_command("colorscheme catppuccin")


