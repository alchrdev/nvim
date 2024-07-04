local bg = '#001111'
local bg_dark = '#001111'
local transparent = true 
local util = '#002929'

require('solarized-osaka').setup({
  transparent = transparent,
  on_colors = function(colors)
    colors.bg = bg
    colors.bg_dark = transparent and colors.none or bg_dark
    colors.bg_float = transparent and colors.none or bg_dark
    colors.bg_sidebar = transparent and colors.none or bg_dark
    colors.bg_statusline = transparent and colors.none or util
    colors.cyan900 = transparent and colors.none or util
  end,
  on_highlights = function(hl, c)
    local seaGreen = '#001A1A'
    -- local forestGreen = '#002929'

    hl.Pmenu = { fg = c.none }
    hl.PmenuSel = { bg = c.cyan900}
    hl.PmenuSbar = { fg = c.base03  }
    hl.PmenuThumb = { fg = c.none }
    hl.CursorLine = { bg = c.cyan900 }
    hl.HarpoonBorder = { fg = c.cyan900 }
    hl.TelescopeSelection = { bg = c.cyan900 }

    -- Configuration without transparency 
    hl.TelescopePromptNormal = { bg = seaGreen }
    hl.TelescopeResultsNormal = { bg = seaGreen }
    hl.TelescopePreviewNormal = { bg = seaGreen}
    hl.TelescopeBorder = { bg = seaGreen }
    hl.TelescopeResultsBorder = { bg = seaGreen, fg = seaGreen }
    hl.TelescopePreviewBorder = { bg = seaGreen, fg = seaGreen }
    hl.TelescopePromptBorder = { bg = seaGreen, fg = seaGreen }
    hl.TelescopePromptTitle = { fg = seaGreen, bg = seaGreen}
    hl.TelescopeResultsTitle = { fg = seaGreen, bg = seaGreen }

    -- Configuration with transparency 
    -- hl.PmenuSel = { bg = forestGreen }
    -- hl.TelescopeBorder = { fg = forestGreen }
    -- hl.TelescopePromptTitle = { fg = forestGreen }
    -- hl.TelescopeResultsTitle = { fg = forestGreen }
    -- hl.NormalFloat = {  bg = c.none}
  end
})

vim.api.nvim_command('colorscheme solarized-osaka')


