return {
{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			require('tokyonight').setup({
				transparent = true,
				styles = {
					sidebars = 'transparent',
					floats = 'transparent',
				},
				on_highlights = function(hl, c)
					local accent = '#24283b'

					hl.TelescopeSelection = { bg = accent }
					hl.TelescopeSelectionCaret = { bg = accent, fg = c.blue }
					hl.TelescopePromptPrefix = { fg = accent }
					hl.MatchParen = { bg = accent, fg = c.blue }
					hl.Visual = { bg = c.bg_highlight }
					hl.PmenuSel = { bg = accent }
					hl.PmenuThumb = { bg = c.none }
					hl.PmenuSbar = { bg = c.none }
					hl.Pmenu = { bg = c.none }
					hl.TelescopeBorder = { fg = accent }
				end,
			})

			vim.api.nvim_command('colorscheme tokyonight-night')
		end,
	},
}

