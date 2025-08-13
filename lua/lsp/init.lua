vim.diagnostic.config({
  virtual_lines = true,
  -- virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
})

-- Keymaps LSP globales
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }
    -- Keymaps básicos
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)
  end,
})

-- Cargar configuraciones de servidores desde archivos separados
local function load_server_config(server_name)
  local ok, config = pcall(require, 'lsp.servers.' .. server_name)
  if ok then
    return config
  end
  return {}
end

-- Configurar cada servidor usando vim.lsp.config
vim.lsp.config.lua_ls = load_server_config('lua_ls')
vim.lsp.config.emmet_ls = load_server_config('emmet_ls')
vim.lsp.config.cssls = load_server_config('cssls')
vim.lsp.config.tailwindcss = load_server_config('tailwindcss')
vim.lsp.config.html = load_server_config('html')

-- Habilitar todos los LSP servers
vim.lsp.enable({
  'lua_ls',
  'emmet_ls',
  'cssls',
  'tailwindcss',
  'html'
})
