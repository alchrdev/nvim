vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

local status_ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

ts_configs.setup({
  ensure_installed = {
    'html',
    'css',
    'yaml',
    'typescript',
    'tsx',
    'javascript',
  },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
})
