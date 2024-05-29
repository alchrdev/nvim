return {
  {
    "catppuccin/nvim",
    priority = 1000,
    name = "catppuccin",
    config = function()
      require("custom.midnight-monochrome")
    end,
  },
}
