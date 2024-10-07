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
          transparency = false,
        },
        palette = {
          main = {
            base = '#141420',
            surface = '#141420',
          },
        },

        highlight_groups = {
          Pmenu =  { bg = 'NONE' },
          PmenuThumb = { bg = 'NONE' },
          PmenuSbar = { bg = 'NONE'},
          HarpoonBorder = { fg = '#524360' },
          TelescopePromptPrefix = { fg = '#524360' },
          TelescopeSelectionCaret = { bg = '#4d4763', fg = '#4d4763' },
          TelescopePromptCounter = { fg = '#524360' },
          VertSplit = { fg = '#2a2734' },
          WinSeparator = { fg = '#2a2734' },

          -- Highlight groups adjusted for different transparency settings.
          -- When transparency is disabled, both foreground and background colors are applied.

          RenderMarkdownCode = { bg = '#261f2d' },
          RenderMarkdownCodeInline = { bg = '#261f2d' },
          PmenuSel = { bg = '#261f2d' },
          TelescopeSelection  = { bg = '#261f2d' },
          TelescopePromptNormal = { bg = '#1a1824' },
          TelescopeResultsNormal = { bg = '#1a1824' },
          TelescopePreviewNormal = { bg = '#1a1824' },
          TelescopeBorder = { bg = '#443c63' },
          TelescopeResultsBorder = { bg = '#1a1824', fg = '#1a1824' },
          TelescopePreviewBorder = { bg = '#1a1824', fg = '#1a1824' },
          TelescopePromptBorder = { bg = '#1a1824', fg = '#1a1824' },
          TelescopePromptTitle = { fg = '#1a1824', bg = '#1a1824' },
          TelescopeResultsTitle = { fg = '#1a1824', bg = '#1a1824' },
          TelescopePreviewTitle = { fg = '#1a1824', bg = '#1a1824' },
          MiniStatuslineFilename = { bg = '#1a1824' },
          MiniStatuslineDevinfo = { bg = '#1a1824'},

          -- When transparency is enabled, only foreground colors are applied. 
          -- PmenuSel = { bg = '#373148' },
          -- TelescopeBorder = { fg = '#373148' },
          -- TelescopeSelection  = { bg = '#373148' },
          -- TelescopePreviewTitle = { fg = '#524360' },
          -- TelescopePromptTitle = { fg = '#524360' },
          -- TelescopeResultsTitle = { fg = '#524360' },
          -- RenderMarkdownCode = { bg = '#3a3240' },
          -- RenderMarkdownCodeInline = { bg = '#3a3240' },
          -- MiniStatuslineFilename = { bg= 'NONE' },
          -- MiniStatuslineFileinfo = { bg = 'NONE' },
          -- MiniStatuslineMode = { bg = 'NONE' },
        },
      })

      vim.api.nvim_command('colorscheme rose-pine')
    end,
  },
}
