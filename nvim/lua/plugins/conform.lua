local M = {
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { sql = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			json = { "prettier" },
			jsonc = { "prettier" },
			php = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettierv2" },
			javascript = { "prettier" },
			python = { "black" },
			css = { "prettier" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			templ = { "templ" },
		},
		formatters = {
			["clang-format"] = {
				prepend_args = { "-style={IndentWidth: 4, AllowShortFunctionsOnASingleLine: Empty}" },
			},
			["prettier"] = {
				prepend_args = { "--tab-width", "4" },
			},
		},
	},
}

return M
