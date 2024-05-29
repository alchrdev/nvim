return {
  { -- Visualize and navigate undo history
    "mbbill/undotree",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { noremap = true, silent = true })
    end,
  },
}
