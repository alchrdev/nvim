return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require 'gitsigns'
      gitsigns.setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
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
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
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
            { buffer = bufnr, desc = 'Preview git hunk '})

          vim.keymap.set('n', ']]', require("gitsigns").next_hunk,
            { buffer = bufnr, desc = 'Next git hunk '})

          vim.keymap.set('n', '[[', require("gitsigns").prev_hunk,
            { buffer = bufnr, desc = 'Previous git hunk '})
        end
      }
      vim.keymap.set(
        'n',
        '<leader>gs',
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
        ':Gitsigns stage_hunk<cr>',
        { noremap = true, silent = true, desc = 'Stage [h]unk' }
      )
    end,
  },

  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>go', ':Git<cr>', { noremap = true, silent = true, desc = '[o]pen' })
      vim.keymap.set('n', '<leader>gb', ':Git blame<cr>', { noremap = true, silent = true, desc = '[b]lame' })
    end,
  },
}
