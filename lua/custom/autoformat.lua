local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd.with({
      filetypes = {
        'html',
        'css',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'markdown',
        'json',
        'yaml',
        'lua',
      },
    }),
    -- JavaScript / TypeScript
    require('none-ls.diagnostics.eslint_d').with({
      diagnostics_format = '[eslint] #{m}\n(#{c})',
      condition = function(utils)
        return utils.root_has_file({
          '.eslintrc',
          '.eslintrc.js',
          '.eslintrc.cjs',
          '.eslintrc.yaml',
          '.eslintrc.yml',
          '.eslintrc.json',
        })
      end,
    }),
  },
})

vim.keymap.set('n', '<leader>fd', vim.lsp.buf.format, {})
