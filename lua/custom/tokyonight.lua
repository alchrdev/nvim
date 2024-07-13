local bg = '#0f1014'
local bg_dark = '#0f1014'
local transparent = true
local util = '#1f202e'

require('tokyonight').setup({
  transparent = transparent,
  style = 'night',
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
  on_colors = function(colors)
    colors.bg = bg
    colors.bg_dark = transparent and colors.none or bg_dark
    colors.bg_float = transparent and colors.none or bg_dark
    colors.bg_sidebar = transparent and colors.none or bg_dark
    colors.bg_statusline = transparent and colors.none or util
  end,
  on_highlights = function(hl, c)
    -- local midnightBlue = '#111118'
    local nightfallBlue = '#1f202e'

    hl.Pmenu = { fg = c.none }
    hl.PmenuSel = { bg = nightfallBlue}
    hl.PmenuSbar = { fg = c.base03  }
    hl.PmenuThumb = { fg = c.none }
    hl.FloatBorder = { fg = nightfallBlue }
    hl.CursorLine = { bg = c.cyan900 }
    hl.HarpoonBorder = { fg = nightfallBlue }
    hl.TelescopeSelection = { bg = nightfallBlue }
    hl.TelescopePromptPrefix = { fg = nightfallBlue }
    hl.TelescopePromptCounter = { fg = nightfallBlue }
    hl.Visual = { bg = nightfallBlue }

    -- Configuration without transparency 
    -- hl.TelescopePromptNormal = { bg = midnightBlue }
    -- hl.TelescopeResultsNormal = { bg = midnightBlue }
    -- hl.TelescopePreviewNormal = { bg = midnightBlue}
    -- hl.TelescopeBorder = { bg = midnightBlue }
    -- hl.TelescopeResultsBorder = { bg = midnightBlue, fg = midnightBlue }
    -- hl.TelescopePreviewBorder = { bg = midnightBlue, fg = midnightBlue }
    -- hl.TelescopePromptBorder = { bg = midnightBlue, fg = midnightBlue }
    -- hl.TelescopePromptTitle = { fg = midnightBlue, bg = midnightBlue}
    -- hl.TelescopeResultsTitle = { fg = midnightBlue, bg = midnightBlue }

    -- Configuration with transparency 
    hl.TelescopeBorder = { fg = nightfallBlue }
    hl.TelescopePromptBorder = { fg = nightfallBlue }
    hl.TelescopePromptTitle = { fg = nightfallBlue }
    hl.TelescopeResultsTitle = { fg = nightfallBlue }
    hl.NormalFloat = {  bg = c.none }
  end
})

vim.api.nvim_command('colorscheme tokyonight')


