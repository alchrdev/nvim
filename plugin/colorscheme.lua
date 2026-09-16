vim.pack.add({ 'https://github.com/rose-pine/neovim' })

require('rose-pine').setup({
  styles = {
    transparency = true,
  },
  
  palette = {
    main = {
      base = '#191724',     
      surface = '#1f1d2e', 
      iris = '#b58ae0',    
    },
  },

  highlight_groups = {
    FloatTitle = { bg = 'NONE', fg = 'iris' },
    SnacksPickerTitle = { bg = 'NONE', fg = 'iris', bold = false },
    MiniStatuslineDevinfo = { bg = 'NONE' },
    MiniStatuslineFilename = { bg = 'NONE' }
  }
})

local ok, _ = pcall(vim.cmd.colorscheme, 'rose-pine')
if not ok then
  vim.notify('Fallo al inicializar rose-pine tras vim.pack.add', vim.log.levels.ERROR)
end
