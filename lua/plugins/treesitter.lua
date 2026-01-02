return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = { "html", "css", "markdown", "vim", "vimdoc", "typescript", "lua", "tsx", "javascript" },       sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end
}
