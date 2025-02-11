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

    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')
    local icons = require('config.icons')

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require('luasnip.loaders.from_vscode').lazy_load()
    -- require('luasnip.loaders.from_vscode').lazy_load({ paths = { '~/.config/nvim/snippets/' } })
    require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath('config') .. '\\snippets\\' } })

    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,preview,noselect',
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(), -- previous suggestion
        ['<C-n>'] = cmp.mapping.select_next_item(), -- next suggestion
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
        ['<C-e>'] = cmp.mapping.abort(),      -- close completion window
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = function(entry, vim_item)
          vim_item.dup = { buffer = 1, path = 1, nvim_lsp = 0 }
          local max_width = 0
          if max_width ~= 0 and #vim_item.abbr > max_width then
            vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
          end
          if vim_item.kind then
            vim_item.kind = icons.kind[vim_item.kind] or lspkind.presets.default[vim_item.kind] .. ' ' .. vim_item.kind
          else
            vim_item.kind = ''
          end

          if entry.source.name == 'copilot' then
            vim_item.kind = icons.git.Octoface
            vim_item.kind_hl_group = 'CmpItemKindCopilot'
          end

          if entry.source.name == 'crates' then
            vim_item.kind = icons.misc.Package
            vim_item.kind_hl_group = 'CmpItemKindCrate'
          end

          if entry.source.name == 'emoji' then
            vim_item.kind = icons.misc.Smiley
            vim_item.kind_hl_group = 'CmpItemKindEmoji'
          end
          vim_item.menu = ({
            nvim_lsp = '(LSP)',
            emoji = '(Emoji)',
            path = '(Path)',
            calc = '(Calc)',
            vsnip = '(Snippet)',
            luasnip = '(Snippet)',
            buffer = '(Buffer)',
            tmux = '(TMUX)',
            copilot = '(Copilot)',
            treesitter = '(TreeSitter)',
          })[entry.source.name]
          return require('tailwindcss-colorizer-cmp').formatter(entry, vim_item)
        end,
      },
    })
  end,
}
