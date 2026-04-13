vim.schedule(function()
  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      json = { 'jq' },
      jsonc = { 'jq' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettier' },
      -- html     = { 'prettier' },
      -- markdown = { 'prettier' },
    },
    formatters = {
      jq = { args = { '--indent', '2', '.' } },
    },
  })

  vim.keymap.set('', '<leader>f', function()
    require('conform').format({ async = true, lsp_format = 'fallback' })
  end, { desc = '[F]ormat buffer' })
end)
