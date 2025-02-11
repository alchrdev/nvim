return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',

      -- Better search
      -- {
      --   'nvim-telescope/telescope-fzf-native.nvim',
      --   build = 'make',
      --   cond = function()
      --     return vim.fn.executable('make') == 1
      --   end,
      -- },

      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- File browser
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      local actions = require('telescope.actions')
      local icons = require('config.icons')

      require('telescope').setup({
        defaults = {
          mappings = {
            n = {
              ['q'] = actions.close,
            },
          },
          theme = 'ivy',
          prompt_prefix = ' ' .. icons.ui.ChevronShortRight.. '   ',
          layout_strategy = "center",
          layout_config = {
            horizontal = {
              width = 0.5,
              height = 0.4,
              prompt_position = 'top'
            },
          },
          -- We override the ripgrep arguments to include hidden files and ignore files in .git directory
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          preview = false,
          sorting_strategy = "ascending",
        },
        extensions = {
          file_browser = {
            hidden = true,
            respect_gitignore = true, -- I adding/removing this, nothing happens
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- File browser extension
      require('telescope').load_extension('file_browser')

      -- See `:help telescope.builtin`
      local builtin = require('telescope.builtin')

      vim.keymap.set('n', '<leader>er', function()
        require('telescope').extensions.file_browser.file_browser({
          path = vim.fn.getcwd(),
          prompt_title = "File Explorer (Root)",
          hidden = false,
          respect_gitignore = true,
        })
      end, { desc = 'File Explorer at the Root' })

      vim.keymap.set('n', '<leader>eb', function()
        require('telescope').extensions.file_browser.file_browser({
          path = vim.fn.expand('%:p:h'),
          prompt_title = "File Explorer (Current Buffer)",
          hidden = false,
          respect_gitignore = true,
        })
      end, { desc = 'File Explorer in the Current Buffer' })

      vim.keymap.set('n', '<leader>ea', function()
        require('telescope').extensions.file_browser.file_browser({
          path = vim.fn.getcwd(),
          prompt_title = "File Explorer (All Files)",
          hidden = true,
          respect_gitignore = false,
        })
      end, { desc = 'File Explorer with Hidden Files' })

      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>ss', function()
        require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))
      end, { desc = '[S]earch [S]pelling suggestions' })
    end,
  },
}
