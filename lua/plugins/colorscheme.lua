-- Theme: ashen-dusk
-- A custom low-vision friendly adaptation of rose-pine
-- Optimized for reduced eye strain and improved syntax distinction
return {
  {
    'rose-pine/neovim',
    as = 'rose-pine',
    priority = 1000,
    config = function()
      -- Global toggle for transparency (persist across reloads)
      if vim.g.ashen_transparent == nil then
        vim.g.ashen_transparent = true  -- default: transparente
      end

      -- Build highlights depending on mode (solid vs transparent)
      local function build_overlay_highlights(is_solid)
        local t = {
          -- Core Neovim
          CurSearch   = { bg = 'git_visual_bg', fg = 'pine' },
          CursorWord  = { fg = 'reference_text',  bg = 'highlight_med', bold = false },
          CursorWord0 = { fg = 'reference_read',  bg = 'git_visual_bg', bold = false },
          CursorWord1 = { fg = 'reference_write', bg = 'git_command_bg', bold = false },
          FloatBorder = { fg = 'highlight_med' },
          FloatTitle  = { fg = 'pine', bold = true },
          IncSearch   = { bg = 'git_remove_bg', fg = 'iris' },
          Search      = { bg = 'git_add_bg' },
          VertSplit   = { fg = 'highlight_med' },
          Visual      = { bg = 'highlight_med', inherit = false },
          WinSeparator= { fg = 'highlight_low' },
          Directory   = { fg = 'foam', bold = true },

          -- LSP refs
          LspReferenceRead  = { fg = 'reference_read',  bg = 'git_visual_bg', bold = false },
          LspReferenceText  = { fg = 'reference_text',  bg = 'highlight_med', bold = false },
          LspReferenceWrite = { fg = 'reference_write', bg = 'git_command_bg', bold = false },

          -- Git signs
          GitSignsAdd            = { fg = 'git_add_color' },
          GitSignsChange         = { fg = 'git_change_color' },
          GitSignsChangeDelete   = { fg = 'git_change_color' },
          GitSignsDelete         = { fg = 'git_remove_color' },
          GitSignsTopDelete      = { fg = 'git_remove_color' },

          -- mini.statusline (core blocks)
          MiniStatuslineBranch             = { fg = 'rose',             bg = 'branch_bg', bold = true },
          MiniStatuslineDevinfo            = { fg = 'devinfo_text',     bg = 'devinfo_bg' },
          MiniStatuslineFileinfo           = { fg = 'reference_read',   bg = 'fileinfo_bg' },
          MiniStatuslineFilename           = { fg = 'reference_text',   bg = 'filename_bg' },
          MiniStatuslineGitAdd             = { fg = 'git_add_color',    bg = 'git_add_bg' },
          MiniStatuslineGitChange          = { fg = 'git_change_color', bg = 'git_change_bg' },
          MiniStatuslineGitRemove          = { fg = 'git_remove_color', bg = 'git_remove_bg' },
          MiniStatuslineInactiveFileinfo   = { fg = 'inactive_fileinfo_text', bg = 'inactive_fileinfo_bg' },
          MiniStatuslineInactiveFilename   = { fg = 'inactive_text',    bg = 'inactive_border' },
          MiniStatuslineLocation           = { fg = 'location_text',    bg = 'location_bg' },
          MiniStatuslineModeCommand        = { fg = 'gold',             bg = 'git_command_bg' },
          MiniStatuslineModeInsert         = { fg = 'git_add_color',    bg = 'git_add_bg' },
          MiniStatuslineModeNormal         = { fg = 'git_change_color', bg = 'git_change_bg' },
          MiniStatuslineModeReplace        = { fg = 'git_remove_color', bg = 'git_remove_bg' },
          MiniStatuslineModeVisual         = { fg = 'pine',             bg = 'git_visual_bg' },
          MiniIconsAzure                   = { fg = 'foam' },

          -- Render Markdown
          RenderMarkdownDash = { fg = 'highlight_low' },

          -- Snacks
          SnacksDashboardHeader  = { fg = 'pine', bold = true },
          SnacksDashboardIcon    = { fg = 'foam' },
          SnacksDashboardKey     = { fg = 'foam', italic = true },
          SnacksDashboardDesc    = { fg = 'subtle' },
          SnacksDashboardSpecial = { fg = 'reference_text' },
          SnacksDashboardFooter  = { fg = 'reference_text' },
          SnacksPickerTotals     = { fg = 'subtitle_tone' },
          SnacksExplorerGitAdded    = { fg = 'git_add_color' },
          SnacksExplorerGitCommit   = { fg = 'reference_text' },
          SnacksExplorerGitDeleted  = { fg = 'git_remove_color' },
          SnacksExplorerGitIgnored  = { fg = 'muted' },
          SnacksExplorerGitModified = { fg = 'git_change_color' },
          SnacksExplorerGitRenamed  = { fg = 'pine' },
          SnacksExplorerGitStaged   = { fg = 'git_add_color' },
          SnacksExplorerGitUnmerged = { fg = 'iris' },
          SnacksExplorerGitUntracked= { fg = 'subtle' },
          SnacksInputIcon   = { fg = 'iris' },
          SnacksInputPrompt = { fg = 'color_sample' },
          SnacksInputTitle  = { fg = 'text' },
          SnacksInputBorder = { fg = 'color_sample' },
          NotifyINFOTitle   = { fg = 'subtitle_tone' },
          NotifyINFOBorder  = { fg = 'subtitle_tone' },
          NotifyINFOBody    = { fg = 'subtitle_tone' },

          -- RRethy/vim-illuminate
          IlluminatedWordRead  = { fg = 'reference_read',  bg = '#26231a', bold = false },
          IlluminatedWordText  = { fg = 'reference_text',  bg = '#2d2a21', bold = false },
          IlluminatedWordWrite = { fg = 'reference_write', bg = '#3a2a25', bold = false },

          -- Treesitter
          ['@markup.raw.block.markdown']         = { fg = 'text' },
          ['@markup.link.label.markdown_inline'] = { fg = 'gold' },
        }

        -- Parts that change with transparency
        if is_solid then
          t.NormalFloat = { bg = 'base' }
          t.Pmenu       = { bg = 'base' }
          t.PmenuSbar   = { bg = 'highlight_low' }
          t.PmenuThumb  = { bg = 'base' }
          t.SnacksPicker  = { bg = 'color_sample' }
          t.SnacksPickerInputBorder = { bg = 'color_sample', fg = 'highlight_low' }
          t.SnacksPickerInputTitle = { bg = 'color_sample', fg = 'highlight_low' }
          t.SnacksInputBorder = { fg = 'text' }
          t.SnacksPickerBorder = { bg = 'color_sample', fg = 'color_sample' }
          t.RenderMarkdownCode = { bg = 'overlay' }
          t.RenderMarkdownCodeInline  = { bg = 'overlay' }
          t.TroubleNormal = { bg = 'surface' }
          t.TroubleCount  = { bg = 'NONE' }
        else
          t.NormalFloat = { bg = 'NONE' }
          t.Pmenu       = { bg = 'NONE' }
          t.PmenuSbar   = { bg = 'NONE' }
          t.PmenuThumb  = { bg = 'NONE' }
          t.SnacksPicker            = { bg = 'NONE' }
          t.SnacksPickerInputBorder = { bg = 'NONE', fg = 'color_sample' }
          t.SnacksPickerBorder = { fg = 'color_sample' }
          t.RenderMarkdownCode        = { bg = 'NONE' }
          t.RenderMarkdownCodeInline  = { bg = 'NONE' }
          t.TroubleNormal = { bg = 'NONE' }
          t.TroubleCount  = { bg = 'NONE' }
        end

        -- ► Conditional backgrounds for *Border groups (the fix)
        local border_bg = is_solid and 'base' or 'NONE'

        -- Git borders
        t.GitBorderAdd    = { fg = 'git_add_bg',    bg = border_bg }
        t.GitBorderChange = { fg = 'git_change_bg', bg = border_bg }
        t.GitBorderRemove = { fg = 'git_remove_bg', bg = border_bg }

        -- mini.statusline borders
        t.MiniStatuslineModeBorder             = { fg = 'git_change_bg',        bg = border_bg }
        t.MiniStatuslineBranchBorder           = { fg = 'branch_bg',            bg = border_bg }
        t.MiniStatuslineDevinfoBorder          = { fg = 'devinfo_bg',           bg = border_bg }
        t.MiniStatuslineFileinfoBorder         = { fg = 'fileinfo_bg',          bg = border_bg }
        t.MiniStatuslineFilenameBorder         = { fg = 'filename_bg',          bg = border_bg }
        t.MiniStatuslineLocationBorder         = { fg = 'location_bg',          bg = border_bg }
        t.MiniStatuslineInactiveFileinfoBorder = { fg = 'inactive_fileinfo_bg', bg = border_bg }
        t.MiniStatuslineInactiveFilenameBorder = { fg = 'inactive_border',      bg = border_bg }

        -- Lines coherent with mode
        t.StatusLine   = is_solid and { bg = 'base', fg = 'subtle' }        or { bg = 'NONE', fg = 'subtle' }
        t.StatusLineNC = is_solid and { bg = 'base', fg = 'inactive_text' } or { bg = 'NONE', fg = 'inactive_text' }
        t.WinBar       = is_solid and { bg = 'base', fg = 'subtle' }        or { bg = 'NONE', fg = 'subtle' }
        t.WinBarNC     = is_solid and { bg = 'base', fg = 'inactive_text' } or { bg = 'NONE', fg = 'inactive_text' }
        t.TabLine      = is_solid and { bg = 'base', fg = 'subtle' }        or { bg = 'NONE', fg = 'subtle' }
        t.TabLineFill  = is_solid and { bg = 'base', fg = 'subtle' }        or { bg = 'NONE', fg = 'subtle' }

        return t
      end

      -- Apply palette + highlights according to mode
      local function apply_ashen(transp)
        vim.g.ashen_transparent = not not transp
        local is_solid = not vim.g.ashen_transparent

        require('rose-pine').setup({
          variant = 'main',
          dark_variant = 'main',
          dim_inactive_windows = false,
          extend_background_behind_borders = true,

          enable = { terminal = true, legacy_highlights = true, migrations = true },
          styles = { transparency = vim.g.ashen_transparent },

          -- Palette (Flexoki neutrals + adjusted accents)
          palette = {
            main = {
              base    = '#1C1B1A', surface = '#282726', overlay = '#343331',
              text    = '#CECDC3', subtle  = '#878580', muted   = '#6F6E69',
              love    = '#B76E74', gold    = '#B28A4F', rose    = '#937B97',
              pine    = '#8C7D9B', foam    = '#7782A3', iris    = '#96799C',
              highlight_low  = '#282726', highlight_med  = '#343331', highlight_high = '#403E3C',
              branch_bg = '#2C262F',
              git_add_bg = '#252D2C',  git_add_color = '#819787',
              git_change_bg = '#22282B',  git_change_color = '#75929F',
              git_remove_bg = '#2A252B',  git_remove_color = '#B0818B',
              git_visual_bg = '#28252A',  git_command_bg = '#2C2723',
              reference_text = '#9EA2B4', reference_read = '#7C8A96', reference_write = '#8A7C59',
              inactive_border = '#1A1A1A', inactive_text = '#707070',
              inactive_fileinfo_bg = '#1C1F22', inactive_fileinfo_text = '#606B75',
              filename_bg = '#29252B', fileinfo_bg = '#1F2225', devinfo_bg = '#23292D', location_bg = '#1D1F22',
              devinfo_text = '#7A8490', location_text = '#7A8190',
              title_accent = '#4d4355', subtitle_tone = '#7c7565',
              color_sample = '#1f1d1c'
            },
          },

          -- Highlights merged according to transparency
          highlight_groups = build_overlay_highlights(is_solid),
        })

        -- Enforce NONE for borders when transparent (belt & suspenders)
        if not is_solid then
          local force_none = {
            'GitBorderAdd', 'GitBorderChange', 'GitBorderRemove',
            'MiniStatuslineModeBorder','MiniStatuslineBranchBorder','MiniStatuslineDevinfoBorder',
            'MiniStatuslineFileinfoBorder','MiniStatuslineFilenameBorder','MiniStatuslineLocationBorder',
            'MiniStatuslineInactiveFileinfoBorder','MiniStatuslineInactiveFilenameBorder',
          }
          for _, g in ipairs(force_none) do
            vim.api.nvim_set_hl(0, g, { bg = 'NONE' })
          end
        end

        vim.cmd('colorscheme rose-pine')
      end

      -- User commands to toggle
      vim.api.nvim_create_user_command('AshenSolid',       function() apply_ashen(false) end, {})
      vim.api.nvim_create_user_command('AshenTransparent', function() apply_ashen(true)  end, {})
      vim.api.nvim_create_user_command('AshenToggle',      function() apply_ashen(not vim.g.ashen_transparent) end, {})

      -- Load using current flag (preserve last choice)
      apply_ashen(vim.g.ashen_transparent)
    end,
  }
}
