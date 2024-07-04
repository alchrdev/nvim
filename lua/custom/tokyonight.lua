require('tokyonight').setup({
  transparent = true,
  style = 'night',
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
  on_highlights = function(hl, c)
    local midnightBlue = '#1F202E'
    local nightfallBlue = '#292B3D'

    hl.Pmenu = { fg = c.none }
    hl.PmenuSel = { bg = nightfallBlue}
    hl.PmenuSbar = { fg = c.base03  }
    hl.PmenuThumb = { fg = c.none }
    hl.FloatBorder = { fg = nightfallBlue }
    hl.CursorLine = { bg = c.cyan900 }
    hl.HarpoonBorder = { fg = nightfallBlue }
    hl.TelescopeSelection = { bg = nightfallBlue }
    hl.TelescopePromptPrefix = { fg = nightfallBlue }

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
    hl.NormalFloat = {  bg = c.none}
  end
})

vim.api.nvim_command('colorscheme tokyonight')


