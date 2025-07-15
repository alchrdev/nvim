return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    main = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig

    config = function()
      require('render-markdown').setup({
        heading = { enabled = false },
        code = {
            enabled = false,
            render_modes = false,
            sign = true,
            style = 'language',
            language_pad = 0,
            language_name = true,
            disable_background = { 'diff' },
            left_margin = 0,
            left_pad = 0,
            right_pad = 0,
            min_width = 0,
            border = 'none',
            inline_pad = 0,
        },
        callout = {
          note = { raw = '[!NOTE]', rendered = '  Note', highlight = 'RenderMarkdownInfo' },
          tip = { raw = '[!TIP]', rendered = ' Tip', highlight = 'RenderMarkdownSuccess' },
          important = { raw = '[!IMPORTANT]', rendered = '󱥁 Important', highlight = 'RenderMarkdownHint' },
          warning = { raw = '[!WARNING]', rendered = '󰞏 Warning', highlight = 'RenderMarkdownWarn' },
          caution = { raw = '[!CAUTION]', rendered = '󰝧 Caution', highlight = 'RenderMarkdownError' },
          -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
          abstract = { raw = '[!ABSTRACT]', rendered = ' Abstract', highlight = 'RenderMarkdownInfo' },
          summary = { raw = '[!SUMMARY]', rendered = '󱃔 Summary', highlight = 'RenderMarkdownInfo' },
          tldr = { raw = '[!TLDR]', rendered = '󰈬 Tldr', highlight = 'RenderMarkdownInfo' },
          info = { raw = '[!INFO]', rendered = '󰋼 Info', highlight = 'RenderMarkdownInfo' },
          todo = { raw = '[!TODO]', rendered = '󰗠 Todo', highlight = 'RenderMarkdownInfo' },
          hint = { raw = '[!HINT]', rendered = '󰅺 Hint', highlight = 'RenderMarkdownSuccess' },
          success = { raw = '[!SUCCESS]', rendered = ' Success', highlight = 'RenderMarkdownSuccess' },
          check = { raw = '[!CHECK]', rendered = ' Check', highlight = 'RenderMarkdownSuccess' },
          done = { raw = '[!DONE]', rendered = '󰗠 Done', highlight = 'RenderMarkdownSuccess' },
          question = { raw = '[!QUESTION]', rendered = '󰠗 Question', highlight = 'RenderMarkdownWarn' },
          help = { raw = '[!HELP]', rendered = ' Help', highlight = 'RenderMarkdownWarn' },
          faq = { raw = '[!FAQ]', rendered = '󰭙 Faq', highlight = 'RenderMarkdownWarn' },
          attention = { raw = '[!ATTENTION]', rendered = '󰀩 Attention', highlight = 'RenderMarkdownWarn' },
          failure = { raw = '[!FAILURE]', rendered = '󱔶 Failure', highlight = 'RenderMarkdownError' },
          fail = { raw = '[!FAIL]', rendered = ' Fail', highlight = 'RenderMarkdownError' },
          missing = { raw = '[!MISSING]', rendered = '󱐢 Missing', highlight = 'RenderMarkdownError' },
          danger = { raw = '[!DANGER]', rendered = '󰀦 Danger', highlight = 'RenderMarkdownError' },
          error = { raw = '[!ERROR]', rendered = '󰮘 Error', highlight = 'RenderMarkdownError' },
          bug = { raw = '[!BUG]', rendered = ' Bug', highlight = 'RenderMarkdownError' },
          example = { raw = '[!EXAMPLE]', rendered = '󱉯 Example', highlight = 'RenderMarkdownHint' },
          quote = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote' },
          cite = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote' },
        },
      })
    end
  },
}
