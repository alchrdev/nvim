return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    main = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  }
}