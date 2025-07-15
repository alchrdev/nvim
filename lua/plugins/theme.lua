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
  -- Theme: rose-pine-dusk
  -- A custom low-vision friendly adaptation of rose-pine
  -- Optimized for reduced eye strain and improved syntax distinction
  {
    'rose-pine/neovim',
    as = 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        variant = "main",
        dark_variant = "main",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,

        enable = {
          terminal = true,
          legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
          migrations = true, -- Handle deprecated options automatically
        },
        styles = {
          transparency = true,
        },
        palette = {

          main = {
            -- Base and UI layers
            base = '#191919',
            surface = '#242424',
            overlay = '#2E2E2E',

            -- Text tones
            text = '#ABB2BF',
            subtle = '#828997',
            muted = '#5C6370',

            -- Syntax accents
            love = '#AA555C',
            gold = '#63829C',
            rose = '#8A4A6F',
            pine = '#7C6C8C',
            foam = '#689D9A',
            iris = '#8A6B91',

            -- Highlights
            highlight_low = '#242424',
            highlight_med = '#2A2A2A',
            highlight_high = '#3C3C3C',

            -- Custom color variables for repeated hex values
            branch_bg = '#2C262F',
            git_add_bg = '#252D2C',
            git_change_bg = '#22282B',
            git_remove_bg = '#2A252B',
            git_visual_bg = '#28252A',
            git_command_bg = '#2C2723',

            reference_text = '#9EA2B4',
            reference_read = '#7C8A96',
            reference_write = '#8A7C59',

            git_add_color = '#6C8372',
            git_change_color = '#5E7A87',
            git_remove_color = '#8F5A65',

            inactive_border = '#1A1A1A',
            inactive_text = '#707070',
            inactive_fileinfo_bg = '#1C1F22',
            inactive_fileinfo_text = '#606B75',

            filename_bg = '#29252B',
            fileinfo_bg = '#1F2225',
            devinfo_bg = '#23292D',
            location_bg = '#1D1F22',

            devinfo_text = '#7A8490',
            location_text = '#7A8190',
          },
        },

        highlight_groups = {
          -- Core Neovim highlights
          CurSearch = { bg = 'git_visual_bg', fg = 'pine' },
          CursorWord = { fg = 'reference_text', bg = 'highlight_med', bold = false },
          CursorWord0 = { fg = 'reference_read', bg = 'git_visual_bg', bold = false },
          CursorWord1 = { fg = 'reference_write', bg = 'git_command_bg', bold = false },
          FloatBorder = { fg = 'gold' },
          FloatTitle = { fg = 'gold' },
          IncSearch = { bg = 'git_remove_bg', fg = 'iris' },
          NormalFloat = { bg = 'NONE' },
          Pmenu = { bg = 'NONE' },
          PmenuSbar = { bg = 'NONE' },
          PmenuThumb = { bg = 'NONE' },
          Search = { bg = 'git_add_bg', fg = 'foam' },
          VertSplit = { fg = 'highlight_low' },
          Visual = { bg = 'highlight_med', inherit = false },
          WinSeparator = { fg = 'highlight_low' },

          -- LSP highlights
          LspReferenceRead = { fg = 'reference_read', bg = 'git_visual_bg', bold = false },
          LspReferenceText = { fg = 'reference_text', bg = 'highlight_med', bold = false },
          LspReferenceWrite = { fg = 'reference_write', bg = 'git_command_bg', bold = false },

          -- Git-related highlights
          GitBorderAdd = { fg = 'git_add_bg', bg = 'base' },
          GitBorderChange = { fg = 'git_change_bg', bg = 'base' },
          GitBorderRemove = { fg = 'git_remove_bg', bg = 'base' },
          GitSignsAdd = { fg = 'git_add_color' },
          GitSignsChange = { fg = 'git_change_color' },
          GitSignsChangeDelete = { fg = 'git_change_color' },
          GitSignsDelete = { fg = 'git_remove_color' },
          GitSignsTopDelete = { fg = 'git_remove_color' },

          -- Harpoon plugin
          HarpoonBorder = { fg = 'gold' },

          -- Mini.nvim statusline
          MiniStatuslineBranch = { fg = '#9B7D9E', bg = 'branch_bg', bold = true },
          MiniStatuslineBranchBorder = { fg = 'branch_bg', bg = 'base' },
          MiniStatuslineDevinfo = { fg = 'devinfo_text', bg = 'devinfo_bg' },
          MiniStatuslineDevinfoBorder = { fg = 'devinfo_bg', bg = 'base' },
          MiniStatuslineFileinfo = { fg = 'reference_read', bg = 'fileinfo_bg' },
          MiniStatuslineFileinfoBorder = { fg = 'fileinfo_bg', bg = 'base' },
          MiniStatuslineFilename = { fg = 'reference_text', bg = 'filename_bg' },
          MiniStatuslineFilenameBorder = { fg = 'filename_bg', bg = 'base' },
          MiniStatuslineGitAdd = { fg = 'git_add_color', bg = 'git_add_bg' },
          MiniStatuslineGitChange = { fg = 'git_change_color', bg = 'git_change_bg' },
          MiniStatuslineGitRemove = { fg = 'git_remove_color', bg = 'git_remove_bg' },
          MiniStatuslineInactiveFileinfo = { fg = 'inactive_fileinfo_text', bg = 'inactive_fileinfo_bg' },
          MiniStatuslineInactiveFileinfoBorder = { fg = 'inactive_fileinfo_bg', bg = 'base' },
          MiniStatuslineInactiveFilename = { fg = 'inactive_text', bg = 'inactive_border' },
          MiniStatuslineInactiveFilenameBorder = { fg = 'inactive_border', bg = 'base' },
          MiniStatuslineLocation = { fg = 'location_text', bg = 'location_bg' },
          MiniStatuslineLocationBorder = { fg = 'location_bg', bg = 'base' },
          MiniStatuslineModeCommand = { fg = 'reference_write', bg = 'git_command_bg' },
          MiniStatuslineModeInsert = { fg = 'git_add_color', bg = 'git_add_bg' },
          MiniStatuslineModeBorder = { fg = 'git_change_bg', bg = 'base' },
          MiniStatuslineModeNormal = { fg = 'git_change_color', bg = 'git_change_bg' },
          MiniStatuslineModeReplace = { fg = 'git_remove_color', bg = 'git_remove_bg' },
          MiniStatuslineModeVisual = { fg = 'pine', bg = 'git_visual_bg' },

          -- Render-markdown plugin
          RenderMarkdownCode = { bg = 'NONE' },
          RenderMarkdownCodeInline = { bg = 'NONE' },
          RenderMarkdownDash = { fg = 'highlight_low' },

          -- Snacks plugin - Dashboard
          SnacksDashboardHeader = { fg = 'gold', bold = true },
          SnacksDashboardIcon = { fg = 'gold' },
          SnacksDashboardKey = { fg = 'reference_text', italic = true },
          SnacksDashboardDesc = { fg = 'subtle' },
          SnacksDashboardSpecial = { fg = 'subtle' },
          SnacksDashboardFooter = { fg = 'muted' },

          -- Snacks plugin - Explorer
          SnacksExplorerGitAdded = { fg = 'git_add_color' },
          SnacksExplorerGitCommit = { fg = 'reference_text' },
          SnacksExplorerGitDeleted = { fg = 'git_remove_color' },
          SnacksExplorerGitIgnored = { fg = 'muted' },
          SnacksExplorerGitModified = { fg = 'git_change_color' },
          SnacksExplorerGitRenamed = { fg = 'pine' },
          SnacksExplorerGitStaged = { fg = 'git_add_color' },
          SnacksExplorerGitUnmerged = { fg = 'iris' },
          SnacksExplorerGitUntracked = { fg = 'subtle' },

          -- Snacks plugin - Input
          SnacksInputIcon = { fg = 'gold' },
          SnacksInputPrompt = { fg = 'gold' },
          SnacksInputTitle = { fg = 'gold' },

          -- Snacks plugin - Picker
          SnacksPicker = { bg = 'NONE' },
          SnacksPickerIcon = { fg = 'gold' },
          SnacksPickerInputBorder = { bg = 'NONE', fg = 'gold' },
          SnacksPickerPrompt = { fg = 'gold' },

          -- Trouble plugin
          TroubleNormal = { bg = 'NONE' },
          TroubleCount = { bg = 'NONE' },

          -- Vim-illuminate plugin
          IlluminatedWordRead = { fg = 'reference_read', bg = 'git_visual_bg', bold = false },
          IlluminatedWordText = { fg = 'reference_text', bg = 'highlight_med', bold = false },
          IlluminatedWordWrite = { fg = 'reference_write', bg = 'git_command_bg', bold = false },

          -- Uncomment below for snacks indent plugin
          -- SnacksIndent = { fg = 'overlay', bg = 'NONE' }, 
          -- SnacksIndentScope = { fg = '#707070', bg = 'NONE' }, 
        },
      })

      vim.api.nvim_command('colorscheme rose-pine')
    end,
  }

}
