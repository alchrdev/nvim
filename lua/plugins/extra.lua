return {
  { -- Comments
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  { -- Visualize and navigate undo history
    'mbbill/undotree',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { noremap = true, silent = true })
    end,
  },

  { -- Surround
    'tpope/vim-surround',
  },

  { -- Auto tags
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  { -- Maximize window toggling
    'szw/vim-maximizer',
    keys = {
      { '<leader>z', '<CMD>MaximizerToggle<CR>', desc = 'Maximize Window', silent = true },
      {
        '<leader>z',
        '<CMD>MaximizerToggle<CR>gv',
        mode = 'v',
        desc = 'Maximize Window',
        silent = true,
      },
    },
    init = function()
      vim.g.maximizer_set_default_mapping = 0
    end,
  },


  { -- Displays colors inline (hex, etc)
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = {
        "css",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        html = { mode = "foreground" },
      },
      user_default_options = {
        tailwind = true,
      },
    },
  },

  { -- Markdown preview
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
}
