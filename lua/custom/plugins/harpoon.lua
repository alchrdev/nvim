return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harpoon').setup {
      tabline = false,
      tabline_prefix = " ",
      tabline_suffix = "  ",
      menu = {
        width = 80,
      },
    }

    vim.keymap.set('n', '<leader>ho', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', { desc = 'Toggle' })
    vim.keymap.set('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<cr>', { desc = 'Add file' })

    vim.keymap.set('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', { desc = 'Go to file 1' })
    vim.keymap.set('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', { desc = 'Go to file 2' })
    vim.keymap.set('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', { desc = 'Go to file 3' })
    vim.keymap.set('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', { desc = 'Go to file 4' })
    vim.keymap.set('n', '<leader>5', '<cmd>lua require("harpoon.ui").nav_file(5)<cr>', { desc = 'Go to file 5' })

  end
}
