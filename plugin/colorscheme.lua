vim.pack.add({ 'https://github.com/rose-pine/neovim' })

local P = {
  base = '#191724',
  surface = '#1f1d2e',
  overlay = '#232220',
  highlight_low = '#242322',
  highlight_med = '#2A2928',
  highlight_high = '#383634',
  love = '#eb6f92',
  pine = '#31748f',
  rose = '#ebbcba',
  foam = '#9ccfd8',
  gold = '#f6c177',
  iris = '#b58ae0',
  text = '#e0def4',
  subtle = '#908caa',
  muted = '#6e6a86',
  sample = '#00ff00',
}

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'rose-pine',
  callback = function()
    local highlights = {
      FloatTitle = { bg = P.surface, fg = P.iris },
      SnacksPickerTitle = { bg = P.surface, fg = P.iris, bold = false },
    }
    for name, spec in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, spec)
    end
  end,
})

local ok, _ = pcall(vim.cmd.colorscheme, 'rose-pine')
if not ok then
  vim.notify('Fallo al inicializar rose-pine tras vim.pack.add', vim.log.levels.ERROR)
end
