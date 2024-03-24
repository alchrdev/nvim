return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harpoon').setup {
      tabline = false,
      tabline_prefix = ' ',
      tabline_suffix = '  ',
    }

    vim.keymap.set('n', '<leader>ho', "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = 'Toggle' })
    vim.keymap.set('n', '<leader>ha', "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = 'Add file' })

    vim.keymap.set('n', '<leader>hn', "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = 'Go next' })
    vim.keymap.set('n', '<leader>hp', "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = 'Go prev' })

    vim.keymap.set(
      'n',
      '<leader>1',
      "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",
      { desc = "Go 1", noremap = true }
    )
    vim.keymap.set(
      'n',
      '<leader>2',
      "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",
      { desc = "Go 2", noremap = true }
    )
    vim.keymap.set(
      'n',
      '<leader>3',
      "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",
      { desc = "Go 3", noremap = true }
    )
    vim.keymap.set(
      'n',
      '<leader>4',
      "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",
      { desc = "Go 4", noremap = true }
    )
  end,
}
