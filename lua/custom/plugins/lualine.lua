return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
  config = function()
    require('custom.lualine')
  end,
}
