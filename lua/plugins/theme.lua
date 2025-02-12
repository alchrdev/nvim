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
    'rose-pine/neovim',
    as = 'rose-pine',
    priority = 1000,
    config = function()

      require('rose-pine').setup({
        styles = {
          transparency = true,
        },
        palette = {
          main = {
            -- base = '#141420', --twilight
            -- surface = '#141420',--twilight
            base = '#000000', --nightfall
            surface = '#000000', --nightfall
          },
        },

        highlight_groups = {
          Pmenu =  { bg = 'NONE' },
          PmenuThumb = { bg = 'NONE' },
          PmenuSbar = { bg = 'NONE'},
          PmenuSel = { bg = '#261f2d' },
          HarpoonBorder = { fg = '#463e59' },

          -- Highlight groups adjusted for different transparency settings.
          -- When transparency is disabled, both foreground and background colors are applied.
          -- VertSplit = { fg = '#2a2734' },
          -- WinSeparator = { fg = '#2a2734' },
          -- RenderMarkdownDash = { fg = '#261f2d'},
          -- RenderMarkdownCode = { bg = '#261f2d' },
          -- RenderMarkdownCodeInline = { bg = '#261f2d' },
          -- TelescopeSelection  = { bg = '#261f2d' },
          -- TelescopePromptNormal = { bg = '#1a1824' },
          -- TelescopeResultsNormal = { bg = '#1a1824' },
          -- TelescopePreviewNormal = { bg = '#1a1824' },
          -- TelescopeBorder = { bg = '#443c63' },
          -- TelescopeResultsBorder = { bg = '#1a1824', fg = '#1a1824' },
          -- TelescopePreviewBorder = { bg = '#1a1824', fg = '#1a1824' },
          -- TelescopePromptBorder = { bg = '#1a1824', fg = '#1a1824' },
          -- TelescopePromptTitle = { fg = '#1a1824', bg = '#1a1824' },
          -- TelescopeResultsTitle = { fg = '#1a1824', bg = '#1a1824' },
          -- TelescopePreviewTitle = { fg = '#1a1824', bg = '#1a1824' },
          -- TelescopePromptPrefix = { fg = '#524360' },
          -- TelescopeSelectionCaret = { bg = '#4d4763', fg = '#4d4763' },
          -- TelescopePromptCounter = { fg = '#524360' },
          -- MiniStatuslineFilename = { bg = '#1a1824' },
          -- MiniStatuslineDevinfo = { bg = '#1a1824'},

          -- When transparency is enabled, only foreground colors are applied. 
          FloatBorder = { fg = '#463e59' },
          FloatTitle = { fg = '#463e59' },

          SnacksInputBorder = { fg = '#463e59' },
          SnacksInputTitle = { fg = '#463e59' },
          SnacksInputPrompt = { fg = '#463e59' },
          SnacksInputIcon = { fg = '#463e59' },
          SnacksPickerIcon = { fg = '#463e59' },
          SnacksPickerPrompt = { fg = '#463e59'},

          TelescopeBorder = { fg = '#121212' },
          TelescopeSelection  = { bg = '#1d1923' },
          TelescopePreviewTitle = { fg = '#463e59' },
          TelescopePromptTitle = { fg = '#463e59' },
          TelescopeResultsTitle = { fg = '#463e59' },
          TelescopePromptPrefix = { fg = '#463e59' },
          TelescopeSelectionCaret = { bg = '#1d1923', fg = '#1d1923' },
          TelescopePromptCounter = { fg = '#524360' },

          RenderMarkdownDash = { fg = '#463e59'},

          MiniStatuslineFilename = { bg= 'NONE' },
          MiniStatuslineFileinfo = { bg = 'NONE' },
          MiniStatuslineMode = { bg = 'NONE' },
          VertSplit = { fg = '#121212' },
          WinSeparator = { fg = '#121212' },
        },
      })

      vim.api.nvim_command('colorscheme rose-pine')
    end,
  },
}
