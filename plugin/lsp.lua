vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

local servers = { 'html', 'cssls', 'emmet_ls', 'ts_ls', 'lua_ls' }

vim.lsp.config.lua_ls = vim.tbl_deep_extend('force', vim.lsp.config.lua_ls or {}, {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
})

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.bo[args.buf].completeopt = 'menu,menuone,popup,noinsert'
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})
