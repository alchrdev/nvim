return {
  {
    'L3MON4D3/LuaSnip',
    keys = {},
    version = 'v2.*',
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets'  },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'default' },
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },
      signature = {
        enabled = true,
      },
      completion = {
        menu = {
          border = 'single',
          scrolloff = 1,
          scrollbar = false,
          draw = {
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
              { 'kind' },
              { 'source_name' },
            },
          },
        },
        documentation = {
          window = {
            border = 'single',
            scrollbar = false,
            winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
          },
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
    },

    opts_extend = { 'sources.default' },

    config = function(_, opts)
      require('blink.cmp').setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
