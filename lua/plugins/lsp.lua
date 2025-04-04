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
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      -- Enable the following language servers
      local servers = {
        cssls = {},
        emmet_ls = {},
        eslint = {},
        html = {},
        tailwindcss = {},
        tsserver = {
          root_dir = require('lspconfig').util.root_pattern(
            -- 'pnpm-workspace.yaml',
            -- 'yarn.lock',
            -- 'pnpm-lock.yaml',
            '.eslintrc.json',
            '.eslintrc',
            '.git'
          ),
          settings = {
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayVariableTypeHints = false,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayVariableTypeHints = false,
              },
            },
          },
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

      -- You can add other tools here that you want Mason to install for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_map(function(key)
        return key == 'tsserver' and 'ts_ls' or key
      end, vim.tbl_keys(servers or {}))
      vim.list_extend(ensure_installed, {
        -- 'goimports', -- Format imports in Go (gopls includes gofmt already)
        -- 'prettierd', -- Used to format JavaScript, TypeScript, HTML, JSON, etc.
        -- 'eslint_d', -- Used to lint and fix JavaScript, TypeScript, and other web-related code efficiently
        'stylua', -- Used to format Lua code
        -- 'ktlint', -- Used to format (and lint) Kotlin code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            server_name = server_name == 'tsserver' and 'ts_ls' or server_name
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            -- FIXME: workaround for https://github.com/neovim/neovim/issues/28058
            for _, v in pairs(server) do
              if type(v) == 'table' and v.workspace then
                v.workspace.didChangeWatchedFiles = {
                  dynamicRegistration = false,
                  relativePatternSupport = false,
                }
              end
            end
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
