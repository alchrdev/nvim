return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    keys = {
      { '<C-space>', desc = 'Increment selection', mode = 'x' },
      { '<bs>',      desc = 'Schrink selection',   mode = 'x' },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('custom.treesitter')
    end,
  },
}
