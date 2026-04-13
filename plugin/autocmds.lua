local api = vim.api

api.nvim_create_autocmd('BufEnter', { command = [[set formatoptions-=cro]] })

api.nvim_create_autocmd('TextYankPost', {
  group = api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.txt', '*.md', '*.tex' },
  callback = function()
    vim.opt.spell = false
    vim.opt.spelllang = "es"
  end,
})

api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, { command = 'checktime' })
api.nvim_command('autocmd VimResized * wincmd =')
