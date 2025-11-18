-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Remap j/k to handle wrapped lines
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Insert empty lines without going into insert mode
vim.keymap.set('n', '<A-O>', 'O<Esc>', { desc = 'Insert empty line above' })
vim.keymap.set('n', '<A-o>', 'o<Esc>', { desc = 'Insert empty line below' })

-- Move Lines
vim.keymap.set('n', '<A-j>', ':m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', ':m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<cr>==gi', { desc = 'Move up' })

-- Create new file
vim.keymap.set('n', '<leader>nf', '<cmd>enew<cr>', { silent = true, desc = 'New File' })

-- Save file
vim.keymap.set('n', '<leader>w', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- Quit current
vim.keymap.set('n', '<leader>q', ':q!<CR>', opts)

-- Quit all
vim.keymap.set('n', '<leader>Q', 'qa!<CR>', opts)

-- Better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Do not yank with x
vim.keymap.set('n', 'x', '"_x', { silent = true })

-- Split the current line at the cursor position
vim.keymap.set('n', 'X', ':keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>', { silent = true })

-- Window split commands
vim.keymap.set('n', '<leader>-', '<C-W>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>|', '<C-W>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>x', '<C-w>c', { desc = 'Close current split' })

-- Buffers
vim.keymap.set('n', '<Right>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
vim.keymap.set('n', '<Left>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', { desc = "Open new tab" })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { desc = 'Go to previous tab' })

-- Exit on jj and jk
vim.keymap.set('i', 'jj', '<ESC>', opts)
vim.keymap.set('i', 'jk', '<ESC>', opts)

-- Move to start/end of line
vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^', opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'L', '$', opts)

-- Select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', { silent = true })

-- Switch spell checker language between es/en
vim.keymap.set('n', '<leader>es', '<cmd>setlocal spell spelllang=es<cr>', { desc = 'Spell check in Spanish'})
vim.keymap.set('n', '<leader>en', '<cmd>setlocal spell spelllang=en<cr>', { desc = 'Spell check in English'})

-- Toggle relative line numbers
function ToggleRelativeLineNumber()
  if vim.wo.relativenumber == true then
    vim.wo.relativenumber = false
    vim.wo.number = true -- Ensure absolute line numbers are enabled when relative is disabled
  else
    vim.wo.relativenumber = true
    vim.wo.number = true -- Keep absolute line number for the current line
  end
end
vim.keymap.set('n', '<leader>ct', '<cmd>lua ToggleRelativeLineNumber()<cr>', { desc = 'Toggle relative line numbers' })

vim.keymap.set('n', '<leader>at', '<cmd>AshenToggle<CR>', { desc = 'Ashen: toggle transparency' })
