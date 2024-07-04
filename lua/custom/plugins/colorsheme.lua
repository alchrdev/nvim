return {
  {
    'craftzdog/solarized-osaka.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      require('custom.solarized-osaka')
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('custom.tokyonight')
    end,
  }
}

