return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'folke/neodev.nvim', opts = {} },

      -- Autoformatting
      -- 'nvimtools/none-ls.nvim',
      -- 'nvimtools/none-ls-extras.nvim',
    },
    config = function()
      require('neodev').setup({})

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      -- Enable the following language servers
      local servers = {
        cssls = {},
        emmet_ls = {},
        eslint = {},
        html = {},
        tailwindcss = {},
        tsserver = {
          root_dir = require('lspconfig').util.root_pattern('.git'),
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
              },
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }
      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'prettierd',
        -- 'eslint_d',
        'stylua',
      })
      require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
      -- Autoformatting Setup
      -- local null_ls = require('null-ls')
      -- null_ls.setup({
      --   sources = {
      --     null_ls.builtins.formatting.stylua,
      --     null_ls.builtins.formatting.prettierd.with({
      --       filetypes = {
      --         'html',
      --         'css',
      --         'javascript',
      --         'javascriptreact',
      --         'typescript',
      --         'typescriptreact',
      --         'markdown',
      --         'json',
      --         'yaml',
      --         'lua',
      --       },
      --     }),
      --     -- JavaScript / TypeScript
      --     require('none-ls.diagnostics.eslint_d').with({
      --       diagnostics_format = '[eslint] #{m}\n(#{c})',
      --       condition = function(utils)
      --         return utils.root_has_file({
      --           '.eslintrc',
      --           '.eslintrc.js',
      --           '.eslintrc.cjs',
      --           '.eslintrc.yaml',
      --           '.eslintrc.yml',
      --           '.eslintrc.json',
      --         })
      --       end,
      --     }),
      --   },
      -- })
      -- vim.keymap.set('n', '<leader>fd', vim.lsp.buf.format, {})
    end,
  },
}
