return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set(
				"n",
				"<leader>gf",
				"<cmd>tab +Git<cr>",
				{ noremap = true, silent = true, desc = "Open Fugitive" }
			)
		end,
	},
}
