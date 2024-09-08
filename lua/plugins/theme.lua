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
            base = '#141420',
          },
        },

        highlight_groups = {
          Pmenu =  { fg = 'NONE' },
          PmenuThumb = { bg = 'NONE' },
          PmenuSel = { bg = '#2a2734' },
          PmenuSbar = { bg = 'NONE'},
          HarpoonBorder = { fg = '#524360' },
          TelescopeSelection  = { bg = '#2a2734' },
          TelescopePromptPrefix = { fg = '#524360' },
          TelescopeSelectionCaret = { fg = '#524360' },
          TelescopePromptCounter = { fg = '#524360' },
          VertSplit = { fg = '#2a2734' },
          WinSeparator = { fg = '#2a2734' },

          -- Highlight groups adjusted for different transparency settings.
          -- When transparency is disabled, both foreground and background colors are applied.

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

          -- When transparency is enabled, only foreground colors are applied. 
          TelescopeBorder = { fg = '#443c63' },
          TelescopePreviewTitle = { fg = '#524360' },
          TelescopePromptTitle = { fg = '#524360' },
          TelescopeResultsTitle = { fg = '#524360' },
        },
      })

      vim.api.nvim_command('colorscheme rose-pine')

    end,
  },
}
