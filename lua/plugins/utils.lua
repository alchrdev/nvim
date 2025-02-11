return {
  -- Shows color inline for the various colour codes
  {
    'uga-rosa/ccc.nvim',
    config = function()
      require('ccc').setup {
        highlighter = {
          auto_enable = true,
          lsp = false, -- i think doing this would enable tailwindcss colorizer, which is buggy
          filetypes = {
            'css',
            'typescript',
            'typescriptreact',
            'html',
          },
        },
      }
    end,
  },
}
