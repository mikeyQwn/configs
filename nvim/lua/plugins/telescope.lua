local M = {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
			opts = {
				defaults = {
					layout_config = {
						horizontal = {
							preview_cutoff = 0,
						},
					},
				},
			},
		},
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local ok, telescope = pcall(require, "telescope")
		if not ok then
			vim.notify("[telescope.nvim] Failed to load telescope", vim.log.levels.WARN)
			return
		end

		local ok, actions = pcall(require, "telescope.actions")
		if not ok then
			vim.notify("[telescope.nvim] Failed to load telescope.actions", vim.log.levels.WARN)
			return
		end

		local ok, themes = pcall(require, "telescope.themes")
		if not ok then
			vim.notify("[telescope.nvim] Failed to load telescope.themes", vim.log.levels.WARN)
			return
		end

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},
			extensions = {
				["ui-select"] = themes.get_dropdown(),
			},
		})

		-- Safely load extensions
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		local ok, builtin = pcall(require, "telescope.builtin")
		if not ok then
			vim.notify("[telescope.nvim] Failed to load telescope.builtin", vim.log.levels.WARN)
			return
		end

		-- Safe keymap assignment
		local map = vim.keymap.set
		map("n", "<leader>sk", builtin.keymaps)
		map("n", "<leader>ff", builtin.find_files)
		map("n", "<leader>ss", builtin.builtin)
		map("n", "<leader>sw", builtin.grep_string)
		map("n", "<leader>fs", builtin.live_grep)
		map("n", "<leader>sd", builtin.diagnostics)
		map("n", "<leader>sr", builtin.resume)
		map("n", "<leader>s.", builtin.oldfiles)
		map("n", "<leader><leader>", builtin.buffers)

		map("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(themes.get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end)

		map("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end)
	end,
}

return M
