return {
  -- icons
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true,
        color_icons = true,
        strict = true,
      }
    end,
  },

  -- theme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()

      require('tokyonight').setup({
        transparent = true,
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights tokyonight.Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors)
          highlights.Pmenu = { bg = 'NONE'}
          highlights.PmenuThumb = { bg = 'NONE'}
          highlights.PmenuSel = { bg = '#292b3d'}
          highlights.PmenuSbar = { bg = 'NONE'}
          highlights.HarpoonBorder = { fg = '#252737' }
          highlights.Visual = { bg = '#292b3d' }
          highlights.NormalFloat = { bg = '#1a1b26' }
          highlights.FloatBorder = { fg = '#252737' }
          highlights.FloatTitle = { fg = '#252737' }

          highlights.MiniStatuslineFilename = { bg = '#252737' }
          highlights.MiniStatuslineFileinfo = { bg = '#252737' }
          highlights.MiniStatuslineMode = { bg = 'NONE' }

          highlights.SnacksDashboardHeader = { fg = "#4c5372" }
          highlights.SnacksDashboardIcon = { fg = "#4c5372" }
          highlights.SnacksDashboardDesc = { fg = "#4c5372" }
          highlights.SnacksDashboardKey = { fg = "#4c5372" }
          highlights.SnacksDashboardFooter = { fg = "#4c5372" }
          highlights.SnacksDashboardSpecial = { fg = "#4c5372" }

          highlights.SnacksNotifierFooterInfo = { fg = '#252737' }
          highlights.SnacksNotifierBorderInfo = { fg = '#252737' }
          highlights.SnacksNotifierHistoryTitle = { fg = '#4c5372'}
          highlights.SnacksNotifierTitleInfo = { fg = '#4c5372'}
          highlights.SnacksNotifierTitleDebug = { fg = '#4c5372'}
          highlights.SnacksNotifierIconInfo = { fg = '#4c5372'}
          highlights.SnacksNotifierHistoryDateTime = { fg = '#4c5372'}

          highlights.SnacksPicker = { bg = '#1a1b26' }
          highlights.SnacksPickerInputBorder = { bg = 'NONE', fg = '#252737'}
          highlights.SnacksPickerInputTitle = { bg = '#252737', fg = '#4c5372'}
          highlights.SnacksPickerBoxTitle = { bg = '#252737', fg = '#4c5372'}
          highlights.SnacksPickerPrompt = { fg = '#4c5372'}

          highlights.SnacksInputBorder = { fg = '#252737' }
          highlights.SnacksInputTitle = { bg = '#252737', fg = '#4c5372' }
          highlights.SnacksInputPrompt = { fg = '#252737' }
          highlights.SnacksInputIcon = { fg = '#4c5372' }

          highlights.TelescopeNormal = { bg = 'NONE' }
          highlights.TelescopeBorder = { bg = 'NONE', fg = '#252737' }
          highlights.TelescopeSelection  = { bg = '#292b3d' }
          highlights.TelescopeSelectionCaret = { bg = '#1a1b26', fg = '#1a1b26' }
          highlights.TelescopePreviewTitle = { bg = '#252737', fg = '#4c5372' }
          highlights.TelescopePromptTitle = { bg = '#252737', fg = '#4c5372' }
          highlights.TelescopeResultsTitle = { bg = '#252737', fg = '#4c5372' }
          highlights.TelescopePromptBorder = { bg = 'NONE', fg = '#252737' }
          highlights.TelescopePromptPrefix = { fg = '#252737' }
          highlights.TelescopePromptCounter = { fg = '#4c5372' }

          highlights.TroubleNormal = { bg = 'NONE' }

          highlights.RenderMarkdownDash = { fg = '#252737'}
        end,

        cache = true, -- When set to true, the theme will be cached for better performance
      })

      vim.api.nvim_command('colorscheme tokyonight-night')
    end,
  },
}
