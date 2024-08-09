-- contains autocommands that do not require plugins

-- highlights text for a short period of time right after it has been yanked
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("yank-highlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
