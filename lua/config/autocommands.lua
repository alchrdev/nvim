-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands
local api = vim.api

local colors = {
  fg = '#24283b',
  bg = '#1f2335',
}

-- don't auto comment new line
api.nvim_create_autocmd('BufEnter', { command = [[set formatoptions-=cro]] })

-- change the background color of floating windows and borders.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.cmd('highlight NormalFloat guibg=none guifg=none')
    vim.cmd('highlight FloatBorder guifg=' .. colors.fg .. ' guibg=none')
    vim.cmd('highlight NormalNC guibg=none guifg=none')
    vim.cmd('highlight HarpoonBorder guibg=none guifg=#24283b')
    vim.cmd('highlight CursorLine guibg=none guifg=none')
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, { command = 'checktime' })

-- Resize neovim split when terminal is resized
vim.api.nvim_command('autocmd VimResized * wincmd =')

