return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
    },
    config = function()
      require("blink.cmp").setup({
        snippets = {
          preset = "luasnip",
        },
        signature = { enabled = true },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "normal",
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            cmdline = {
              min_keyword_length = 2,
            },
          },
        },
        keymap = {
          ["<C-f>"] = {},
        },
        cmdline = {
          enabled = true,
          completion = { menu = { auto_show = true } },
          keymap = {
            ["<CR>"] = { "accept_and_enter", "fallback" },
          },
        },
        completion = {
          menu = {
            -- border = "none",
            scrolloff = 1,
            scrollbar = false,
            draw = {
              columns = {
                { "kind_icon" },
                { "label" },
                { "kind" },
                -- { "source_name" },
              },
            },
          },
          documentation = {
            window = {
              border = "rounded",
              scrollbar = false,
            },
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },
      })
      require("luasnip.loaders.from_vscode").lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
    end,
  },
}

