return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require 'gitsigns'
      local icons = require('config.icons')

      gitsigns.setup {
        signs = {
          add = {
            text = icons.ui.BoldLineLeft,
          },
          change = {
            text = icons.ui.BoldLineLeft,
          },
          delete = {
            text = icons.ui.Triangle,
          },
          topdelete = {
            text = icons.ui.Triangle,
          },
          changedelete = {
            text = icons.ui.BoldLineLeft,
          },
        },
        signcolumn = false,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with :Gitsigns toggle_current_line_blame
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        status_formatter = nil,
        update_debounce = 200,
        max_file_length = 40000,
        preview_config = {
          border = 'rounded',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },

        on_attach = function (bufnr)
          vim.keymap.set('n', '<leader>H', require("gitsigns").preview_hunk,
            { buffer = bufnr, desc = 'Preview git hunk' })

          vim.keymap.set('n', ']]', function()
            require('gitsigns').nav_hunk('next')
          end, { buffer = bufnr, desc = '[N]ext git hunk' })

          vim.keymap.set('n', '[[', function()
            require('gitsigns').nav_hunk('prev')
          end, { buffer = bufnr, desc = '[P]revious git hunk' })
        end
      }
      vim.keymap.set(
        'n',
        '<leader>gt',
        ':Gitsigns toggle_signs<cr>',
        { noremap = true, silent = true, desc = '[S]igns' }
      )
      vim.keymap.set(
        'n',
        '<leader>gl',
        ':Gitsigns toggle_current_line_blame<cr>',
        { noremap = true, silent = true, desc = '[L]ine blame' }
      )
      vim.keymap.set(
        'n',
        '<leader>gh',
        ':Gitsigns reset_hunk<cr>',
        { noremap = true, silent = true, desc = '[R]eset hunk' }
      )
    end,
  },

  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>go', ':Git<cr>', { noremap = true, silent = true, desc = '[O]pen' })
      vim.keymap.set('n', '<leader>gB', ':Git blame<cr>', { noremap = true, silent = true, desc = '[B]lame' })
      vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', { noremap = true, silent = true, desc = '[G]it commit' })
      vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { noremap = true, silent = true, desc = '[G]it push' })
      vim.keymap.set('n', '<leader>gP', ':Git pull<CR>', { noremap = true, silent = true, desc = '[G]it pull' })
      vim.keymap.set('n', '<leader>ga', ':Git log --oneline --graph --decorate --all<CR>', { noremap = true, silent = true, desc = '[G]it log tree' })
    end,
  },
}
