-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'astro',
    'bash',
    'comment',
    'css',
    'git_config',
    'git_rebase',
    'gitcommit',
    'gitignore',
    'html',
    'javascript',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'markdown_inline',
    'regex',
    'scss',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  },
  -- Autoinstall languages that are not installed
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = '<nop>',
      node_decremental = '<bs>',
    },
  },
}

-- Add some autocmds to map files to the expected syntax
vim.cmd [[
  autocmd BufRead,BufNewFile *.tf set filetype=terraform
  autocmd BufRead,BufNewFile *.tfvars set filetype=terraform
  autocmd BufRead,BufNewFile *.tfstate set filetype=json
  autocmd BufRead,BufNewFile *.yml set filetype=yaml
  autocmd BufRead,BufNewFile *.graphqls set filetype=graphql
]]
