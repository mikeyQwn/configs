local M = {
	"rebelot/kanagawa.nvim",
	config = function()
		local opts = {
			compile = false,
			undercurl = true,
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			colors = {
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors)
				return {}
			end,
			theme = "wave",
			background = {
				dark = "wave",
				light = "lotus",
			},
		}

		local ok, _ = pcall(require, "kanagawa", opts)
		if not ok then
			vim.notify("[telescope.nvim] Failed to load telescope", vim.log.levels.WARN)
			return
		end

		vim.cmd("colorscheme kanagawa-wave")
	end,
}

return M
