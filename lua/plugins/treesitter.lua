return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'main',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter').setup({
      ensure_installed = { 
        "html", "css", "markdown", "markdown_inline", 
        "yaml", "vim", "vimdoc", "typescript", "lua", 
        "tsx", "javascript" 
      },
      sync_install = false,
      auto_install = true,
    })
  end
}