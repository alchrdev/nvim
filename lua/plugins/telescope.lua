
return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',

      -- Better search
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Pretty icons
      { 'nvim-tree/nvim-web-devicons' },

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
          prompt_prefix = ' ' .. icons.ui.Telescope .. '   ',
          selection_caret = icons.ui.TriangleShortArrowRight.. ' ',
          layout_config = {
            horizontal = {
              width = 0.90,
              height = 0.90,
              preview_width = 0.5,
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
        },
        pickers = {
          find_files = {
            file_ignore_patterns = { '^.git/', 'node_modules/' },  -- Ensure we always ignore the .git and node_modules directories
            hidden = false,
          },
          buffers = {
            mappings = {
              i = {
                ['<c-d>'] = actions.delete_buffer,
              },
              n = {
                ['<c-d>'] = actions.delete_buffer,
              },
            },
          },
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

      vim.keymap.set('n', '<leader>se', function()
        require('telescope').extensions.file_browser.file_browser({
          prompt_title = "Search File Browser (Root)",
        })
      end, { desc = '[S]earch File [B]rowser (root)' })

      vim.keymap.set('n', '<leader>sE', function()
        require('telescope').extensions.file_browser.file_browser({
          prompt_title = "Search File Browser Hidden (Buffer)",
          select_buffer = false,
          hidden = true,
          respect_gitignore = false,
        })
      end, { desc = '[S]earch File [B]rowser [H]idden (root)' })

      vim.keymap.set('n', '<leader>sb', function()
        require('telescope').extensions.file_browser.file_browser({
          path = vim.fn.expand('%:p:h'),
          select_buffer = true,
          prompt_title = "Search File Browser (Buffer)",
          file_ignore_patterns = { ".git/" },
        })
      end, { desc = '[S]earch File [B]rowser (buffer)' })


      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sp', builtin.builtin, { desc = '[S]earch [A]ll [P]ickers' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set(
        'n',
        '<leader>/',
        builtin.current_buffer_fuzzy_find,
        { desc = '[/] Fuzzily search in current buffer' }
      )

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>si', function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,
          prompt_title = 'Search Hidden Files',
        })
      end, { desc = '[S]earch [H]idden Files' })

      vim.keymap.set('n', '<leader>sI', function()
        builtin.live_grep({
          additional_args = function()
            return { '--no-ignore' }
          end,
        })
      end, { desc = '[S]earch by [G]rep (Including .gitignore)' })

      -- Shortcut for searching the neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch [N]eovim files' })

      vim.keymap.set('n', '<leader>ss', function()
        require('telescope.builtin').spell_suggest(require('telescope.themes').get_cursor({}))
      end, { desc = '[S]earch [S]pelling suggestions' })
    end,
  },
}
