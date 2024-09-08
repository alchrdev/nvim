return {
  "folke/trouble.nvim",
  opts = {
    focus = true,
  },
  cmd = "Trouble",
  keys = {
    { "<leader>td", "<cmd>Trouble diagnostics toggle<CR>", desc = "[D]iagnostic (Trouble)" },
    { "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[B]uffer Diagnostics" },
    { "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "[Q]uickfix List" },
    { "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "[L]ocation List" },
    { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "[S]ymbols" },
    { "<leader>ta", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "[L][S][P] Definitions / references / ..." },
  }
}
