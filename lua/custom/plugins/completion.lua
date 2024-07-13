return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    'saadparwaiz1/cmp_luasnip', -- for autocompletion
    'onsails/lspkind.nvim',   -- vs-code like pictograms
    'rafamadriz/friendly-snippets',
    { 'roobert/tailwindcss-colorizer-cmp.nvim', config = true }, -- tailwind color support
  },
  config = function()
    require('custom.completion')
  end,
}
