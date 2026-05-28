return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = {
			style = "night",
			transparent = false,
			styles = {
				comments = { italic = true },
				keywords = { italic = false },
				sidebars = "dark",
				floats = "dark",
			},
			on_colors = function(colors)
				colors.bg = "#14161f"
				colors.bg_dark = "#181b25"
				colors.bg_float = "#1f2230"
				colors.bg_popup = "#1f2230"
				colors.bg_sidebar = "#181b25"
				colors.bg_statusline = "#181b25"
				colors.fg = "#cdd5e8"
				colors.fg_dark = "#9aa3bd"
				colors.comment = "#6d7591"
				colors.blue = "#7aa2f7"
				colors.purple = "#bb9af7"
			end,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight-night",
		},
	},
}
