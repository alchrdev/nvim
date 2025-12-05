-- ASHEN-DUSK THEME
-- Low-vision optimized 

return {
  {
    "rose-pine/neovim",
    as = "rose-pine",
    priority = 1000,

    config = function()
      ---------------------------------------------------------------------------
      -- Estado persistente entre sesiones
      ---------------------------------------------------------------------------
      if vim.g.ashen_transparent == nil then
        vim.g.ashen_transparent = false
      end

      ---------------------------------------------------------------------------
      -- PALETA BASE 
      ---------------------------------------------------------------------------
      local P = {
        base = "#1C1B1A",
        surface = "#232220",
        overlay = "#232220",
        highlight_low = "#242322",
        highlight_med = "#2A2928",
        highlight_high = "#383634",

        text = "#CECDC3",
        subtle = "#878580",
        muted = "#6F6E69",

        love = "#B76E74",
        gold = "#B28A4F",
        rose = "#937B97",
        pine = "#8C7D9B",
        foam = "#7782A3",
        iris = "#96799C",

        git_add_bg = "#252D2C",
        git_add_color = "#819787",
        git_change_bg = "#22282B",
        git_change_color = "#75929F",
        git_remove_bg = "#2A252B",
        git_remove_color = "#B0818B",
        git_visual_bg = "#28252A",
        git_command_bg = "#2C2723",

        reference_text  = "#9EA2B4",
        reference_read  = "#7C8A96",
        reference_write = "#8A7C59",

        inactive_border = "#1A1A1A",
        inactive_text   = "#707070",
      }

      ---------------------------------------------------------------------------
      -- HIGHLIGHTS PARA MODO SÓLIDO
      ---------------------------------------------------------------------------
      local function solid_highlights()
        return {

          -- ============================
          -- SYNTAX (TREESITTER)
          -- ============================
          ["@keyword"]                           = { fg = P.love, bold = false },
          ["@keyword.return"]                    = { fg = P.love, bold = false },
          ["@keyword.function"]                  = { fg = P.love, bold = false },
          ["@type"]                              = { fg = P.pine, bold = false },
          ["@type.builtin"]                      = { fg = P.pine, bold = false },
          ["@function"]                          = { fg = P.rose, bold = false },
          ["@function.builtin"]                  = { fg = P.rose, bold = false },
          ["@method"]                            = { fg = P.rose, bold = false },
          ["@variable"]                          = { fg = P.foam },
          ["@variable.parameter"]                = { fg = P.foam },
          ["@variable.builtin"]                  = { fg = P.foam },
          ["@constant"]                          = { fg = P.gold },
          ["@constant.builtin"]                  = { fg = P.gold },
          ["@string"]                            = { fg = P.gold },
          ["@string.special"]                    = { fg = P.gold },
          ["@number"]                            = { fg = P.gold },
          ["@boolean"]                           = { fg = P.gold },
          ["@operator"]                          = { fg = P.iris },
          ["@punctuation"]                       = { fg = P.iris },
          ["@punctuation.delimiter"]             = { fg = P.iris },
          ["@property"]                          = { fg = P.foam },
          ["@field"]                             = { fg = P.foam },
          ["@constructor"]                       = { fg = P.rose },
          ["@tag"]                               = { fg = P.love },
          ["@tag.attribute"]                     = { fg = P.foam },
          ["@attribute"]                         = { fg = P.foam },

          ---------------------------------------------------------------------
          -- EDITOR CORE
          ---------------------------------------------------------------------
          Normal                                 = { bg = P.base, fg = P.text },
          NormalFloat                            = { bg = P.surface, fg = P.text },
          FloatBorder                            = { bg = P.surface, fg = P.surface },
          FloatTitle                             = { bg = P.surface, fg = P.subtle, bold = false },

          CursorLine                             = { bg = P.highlight_low },
          CursorWord                             = { bg = P.highlight_med, fg = P.reference_text },

          Search                                 = { bg = P.git_add_bg },
          IncSearch                              = { bg = P.git_remove_bg, fg = P.iris },

          ---------------------------------------------------------------------
          -- SEPARADORES (invisibles en modo sólido)
          ---------------------------------------------------------------------
          VertSplit                              = { fg = P.base, bg = P.base },
          WinSeparator                           = { fg = P.base, bg = P.base },

          ---------------------------------------------------------------------
          -- WINBAR / TABS 
          ---------------------------------------------------------------------
          WinBar                                 = { bg = P.surface, fg = P.subtle },
          WinBarNC                               = { bg = P.surface, fg = P.muted },

          TabLine                                = { bg = P.surface, fg = P.subtle },
          TabLineFill                            = { bg = P.surface, fg = P.subtle },
          TabLineSel                             = { bg = P.surface, fg = P.text, bold = true },

          ---------------------------------------------------------------------
          -- EXPLORER / SNACKS 
          ---------------------------------------------------------------------
          SnacksExplorerNormal                   = { bg = P.surface, fg = P.text },
          SnacksExplorerBorder                   = { bg = P.surface, fg = P.surface },
          SnacksExplorerTitle                    = { bg = P.surface, fg = P.subtle, bold = false },

          SnacksPicker                           = { bg = P.surface, fg = P.text },
          SnacksPickerBorder                     = { bg = P.surface, fg = P.surface },
          SnacksPickerTitle                      = { bg = P.surface, fg = P.subtle, bold = false },

          ---------------------------------------------------------------------
          -- PMENU (lista desplegable)
          ---------------------------------------------------------------------
          Pmenu                                  = { bg = P.surface, fg = P.text },
          PmenuSbar                              = { bg = P.surface },
          PmenuThumb                             = { bg = P.highlight_med },
          PmenuSel                               = { bg = P.highlight_med, fg = P.text },

          ---------------------------------------------------------------------
          -- INPUTS 
          ---------------------------------------------------------------------
          SnacksInputNormal                      = { bg = P.surface, fg = P.text },
          SnacksInputBorder                      = { bg = P.surface, fg = P.surface },
          SnacksInputTitle                       = { bg = P.surface, fg = P.subtle, bold = false },

          ---------------------------------------------------------------------
          -- MARKDOWN
          ---------------------------------------------------------------------
          ["@markup.raw.block.markdown"]         = { fg = P.text },
          ["@markup.link.label.markdown_inline"] = { fg = P.gold },
          RenderMarkdownCode                     = { bg = P.surface },
          RenderMarkdownCodeInline               = { bg = P.surface },

          ---------------------------------------------------------------------
          -- GIT
          ---------------------------------------------------------------------
          GitSignsAdd                            = { fg = P.git_add_color },
          GitSignsChange                         = { fg = P.git_change_color },
          GitSignsDelete                         = { fg = P.git_remove_color },

          ---------------------------------------------------------------------
          -- LSP REFERENCES
          ---------------------------------------------------------------------
          LspReferenceRead                       = { bg = P.git_visual_bg, fg = P.reference_read },
          LspReferenceText                       = { bg = P.highlight_med, fg = P.reference_text },
          LspReferenceWrite                      = { bg = P.git_command_bg, fg = P.reference_write },

          ---------------------------------------------------------------------
          -- STATUSLINE
          ---------------------------------------------------------------------
          StatusLine                             = { bg = P.surface, fg = P.subtle },
          StatusLineNC                           = { bg = P.surface, fg = P.inactive_text },

          ---------------------------------------------------------------------
          -- SNACKS EXPLORER GIT ICONS 
          ---------------------------------------------------------------------
          SnacksExplorerGitAdded                 = { fg = P.git_add_color, bg = P.surface },
          SnacksExplorerGitModified              = { fg = P.git_change_color, bg = P.surface },
          SnacksExplorerGitDeleted               = { fg = P.git_remove_color, bg = P.surface },
          SnacksExplorerGitStaged                = { fg = P.git_change_color, bg = P.surface },
          SnacksExplorerGitRenamed               = { fg = P.foam, bg = P.surface },
          SnacksExplorerGitUnmerged              = { fg = P.love, bg = P.surface },
          SnacksExplorerGitUntracked             = { fg = P.muted, bg = P.surface },
          SnacksExplorerGitIgnored               = { fg = P.subtle, bg = P.surface, italic = true },
          SnacksExplorerGitCommit                = { fg = P.iris, bg = P.surface },

          ---------------------------------------------------------------------
          -- TELESCOPE (si lo usas en lugar de Snacks)
          ---------------------------------------------------------------------
          TelescopeNormal                        = { bg = P.surface, fg = P.text },
          TelescopeBorder                        = { bg = P.surface, fg = P.surface },
          TelescopeTitle                         = { bg = P.surface, fg = P.subtle, bold = false },
          TelescopePromptNormal                  = { bg = P.surface, fg = P.text },
          TelescopePromptBorder                  = { bg = P.surface, fg = P.surface },
          TelescopePromptTitle                   = { bg = P.surface, fg = P.subtle, bold = false },
          TelescopeResultsNormal                 = { bg = P.surface, fg = P.text },
          TelescopeResultsBorder                 = { bg = P.surface, fg = P.surface },
          TelescopeResultsTitle                  = { bg = P.surface, fg = P.subtle, bold = false },
          TelescopePreviewNormal                 = { bg = P.surface, fg = P.text },
          TelescopePreviewBorder                 = { bg = P.surface, fg = P.surface },
          TelescopePreviewTitle                  = { bg = P.surface, fg = P.subtle, bold = false },
          TelescopeSelection                     = { bg = P.highlight_med, fg = P.text },

          ---------------------------------------------------------------------
          -- NOICE (si usas noice.nvim para cmdline/messages)
          ---------------------------------------------------------------------
          NoicePopupmenu                         = { bg = P.surface, fg = P.text },
          NoicePopupmenuBorder                   = { bg = P.surface, fg = P.surface },
          NoiceCmdlinePopup                      = { bg = P.surface, fg = P.text },
          NoiceCmdlinePopupBorder                = { bg = P.surface, fg = P.surface },
          NoiceCmdlinePopupTitle                 = { bg = P.surface, fg = P.subtle, bold = false },
        }
      end

      ---------------------------------------------------------------------------
      -- HIGHLIGHTS PARA MODO TRANSPARENTE
      ---------------------------------------------------------------------------
      local function transparent_highlights()
        return {

          Normal                   = { bg = "NONE", fg = P.text },
          NormalFloat              = { bg = "NONE", fg = P.text },
          FloatBorder              = { bg = "NONE", fg = P.highlight_med },
          FloatTitle               = { bg = "NONE", fg = P.subtle, bold = false },

          VertSplit                = { fg = P.highlight_low, bg = "NONE" },
          WinSeparator             = { fg = P.highlight_low, bg = "NONE" },

          WinBar                   = { bg = "NONE", fg = P.subtle },
          WinBarNC                 = { bg = "NONE", fg = P.muted },

          Pmenu                    = { bg = "NONE", fg = P.text },
          PmenuSbar                = { bg = "NONE" },
          PmenuThumb               = { bg = "NONE" },
          PmenuSel                 = { bg = P.highlight_med, fg = P.text },

          SnacksPicker             = { bg = "NONE", fg = P.text },
          SnacksPickerBorder       = { bg = "NONE", fg = P.highlight_med },
          SnacksPickerTitle        = { bg = "NONE", fg = P.subtle, bold = false },

          SnacksInputNormal        = { bg = "NONE", fg = P.text },
          SnacksInputBorder        = { bg = "NONE", fg = P.highlight_med },
          SnacksInputTitle         = { bg = "NONE", fg = P.subtle, bold = false },

          RenderMarkdownCode       = { bg = "NONE" },
          RenderMarkdownCodeInline = { bg = "NONE" },

          GitSignsAdd              = { fg = P.git_add_color },
          GitSignsChange           = { fg = P.git_change_color },
          GitSignsDelete           = { fg = P.git_remove_color },

          LspReferenceRead         = { bg = P.git_visual_bg, fg = P.reference_read },
          LspReferenceText         = { bg = P.highlight_med, fg = P.reference_text },
          LspReferenceWrite        = { bg = P.git_command_bg, fg = P.reference_write },

          StatusLine               = { bg = "NONE", fg = P.subtle },
          StatusLineNC             = { bg = "NONE", fg = P.inactive_text },

          ---------------------------------------------------------------------
          -- SNACKS EXPLORER GIT ICONS (modo transparente)
          ---------------------------------------------------------------------
          SnacksExplorerGitAdded                 = { fg = P.git_add_color, bg = "NONE" },
          SnacksExplorerGitModified              = { fg = P.git_change_color, bg = "NONE" },
          SnacksExplorerGitDeleted               = { fg = P.git_remove_color, bg = "NONE" },
          SnacksExplorerGitStaged                = { fg = P.git_change_color, bg = "NONE" },
          SnacksExplorerGitRenamed               = { fg = P.foam, bg = "NONE" },
          SnacksExplorerGitUnmerged              = { fg = P.love, bg = "NONE" },
          SnacksExplorerGitUntracked             = { fg = P.muted, bg = "NONE" },
          SnacksExplorerGitIgnored               = { fg = P.subtle, bg = "NONE", italic = true },
          SnacksExplorerGitCommit                = { fg = P.iris, bg = "NONE" },

          TelescopeNormal          = { bg = "NONE", fg = P.text },
          TelescopeBorder          = { bg = "NONE", fg = P.highlight_med },
          TelescopeTitle           = { bg = "NONE", fg = P.subtle, bold = false },
        }
      end

      ---------------------------------------------------------------------------
      -- MINI STATUSLINE HIGHLIGHTS (SE APLICAN DESPUÉS DE ROSE PINE)
      ---------------------------------------------------------------------------
      local function apply_mini_statusline_highlights(transparent)
        local bg = transparent and "NONE" or P.surface

        local groups = {
          -- Git status colors 
          MiniStatuslineGitAdd    = { fg = P.git_add_color, bg = bg, bold = false },
          MiniStatuslineGitChange = { fg = P.git_change_color, bg = bg, bold = false },
          MiniStatuslineGitRemove = { fg = P.git_remove_color, bg = bg, bold = false },

          MiniStatuslineGitAddBorder           = { fg = P.highlight_med, bg = bg },
          MiniStatuslineGitChangeBorder        = { fg = P.highlight_med, bg = bg },
          MiniStatuslineGitRemoveBorder        = { fg = P.highlight_med, bg = bg },

          -- Mode indicators
          MiniStatuslineModeNormal             = { fg = P.git_change_color, bg = bg, bold = true },
          MiniStatuslineModeInsert             = { fg = P.git_add_color, bg = bg, bold = true },
          MiniStatuslineModeVisual             = { fg = P.pine, bg = bg, bold = true },
          MiniStatuslineModeReplace            = { fg = P.git_remove_color, bg = bg, bold = true },
          MiniStatuslineModeCommand            = { fg = P.gold, bg = bg, bold = true },

          -- Info segments
          MiniStatuslineBranch                 = { fg = P.rose, bg = bg, bold = true },
          MiniStatuslineBranchBorder           = { fg = P.highlight_med, bg = bg },
          MiniStatuslineFileinfo               = { fg = P.foam, bg = bg },
          MiniStatuslineFileinfoBorder         = { fg = P.highlight_med, bg = bg },
          MiniStatuslineFilename               = { fg = P.text, bg = bg },
          MiniStatuslineFilenameBorder         = { fg = P.highlight_med, bg = bg },
          MiniStatuslineLocation               = { fg = P.subtle, bg = bg },
          MiniStatuslineLocationBorder         = { fg = P.highlight_med, bg = bg },

          -- Inactive window
          MiniStatuslineInactiveFilename       = { fg = P.muted, bg = bg },
          MiniStatuslineInactiveFilenameBorder = { fg = P.highlight_med, bg = bg },
          MiniStatuslineInactiveFileinfo       = { fg = P.muted, bg = bg },
          MiniStatuslineInactiveFileinfoBorder = { fg = P.highlight_med, bg = bg },
        }

        for name, spec in pairs(groups) do
          vim.api.nvim_set_hl(0, name, spec)
        end
      end

      ---------------------------------------------------------------------------
      -- FUNCIÓN QUE APLICA EL TEMA SEGÚN EL MODO
      ---------------------------------------------------------------------------
      local function apply_ashen(transp)
        vim.g.ashen_transparent = transp

        require("rose-pine").setup({
          variant = "main",
          dark_variant = "main",
          enable = { terminal = true },
          styles = { transparency = transp },
          palette = { main = P },
          highlight_groups =
            transp and transparent_highlights()
            or solid_highlights(),
        })

        vim.cmd("colorscheme rose-pine")

        -- NOTE: Reaplica MiniStatusline highlights después de Rose Pine
        vim.schedule(function()
          apply_mini_statusline_highlights(transp)
        end)
      end

      ---------------------------------------------------------------------------
      -- AUTOCOMMAND: Reaplica highlights si Rose Pine se recarga
      ---------------------------------------------------------------------------
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "rose-pine",
        callback = function()
          vim.schedule(function()
            apply_mini_statusline_highlights(vim.g.ashen_transparent)
          end)
        end,
      })

      ---------------------------------------------------------------------------
      -- COMANDOS DEL USUARIO
      ---------------------------------------------------------------------------
      vim.api.nvim_create_user_command("AshenSolid", function() apply_ashen(false) end, {})
      vim.api.nvim_create_user_command("AshenTransparent", function() apply_ashen(true) end, {})
      vim.api.nvim_create_user_command("AshenToggle", function() apply_ashen(not vim.g.ashen_transparent) end, {})

      ---------------------------------------------------------------------------
      -- CARGA INICIAL
      ---------------------------------------------------------------------------
      apply_ashen(vim.g.ashen_transparent)
    end,
  }
}
