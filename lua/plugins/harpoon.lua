return {
  'ThePrimeagen/harpoon',
  config = function()
    local mark = require('harpoon.mark')
    local ui = require('harpoon.ui')

    vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Harpoon: Mark File'})
    vim.keymap.set('n', '<leader>ho', ui.toggle_quick_menu, { desc = 'Harpoon: Toggle Menu'})

    vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'Harpoon: File 1'})
    vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'Harpoon: File 2'})
    vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'Harpoon: File 3'})
    vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'Harpoon: File 4'})
  end
}
