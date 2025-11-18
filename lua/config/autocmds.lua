-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands
local api = vim.api

-- don't auto comment new line
api.nvim_create_autocmd('BufEnter', { command = [[set formatoptions-=cro]] })

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

-- Enable spell checking for certain file types
api.nvim_create_autocmd(
  { 'BufRead', 'BufNewFile' },
  {
    pattern = { '*.txt', '*.md', '*.tex' },
    callback = function()
      vim.opt.spell = false
      vim.opt.spelllang = "es"
    end,
  }
)

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, { command = 'checktime' })

-- Resize neovim split when terminal is resized
vim.api.nvim_command('autocmd VimResized * wincmd =')

 vim.api.nvim_create_autocmd("DirChanged", {
    callback = function(ev)
      local cwd = vim.fn.getcwd()
      if cwd:match("akt$") then
        require("snacks").setup({
          picker = {
            defaults = {
              ignore_patterns = { "_fonts/", "%.png$", "%.jpg$", "%.jpeg$", "%.webp$", "%.svg$", "%.gif$" },
            },
          },
        })
      end
    end,
  })
