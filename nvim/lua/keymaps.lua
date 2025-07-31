vim.g.mapleader = " "

vim.keymap.set("n", "<leader>cs", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

vim.keymap.set("n", "<C-w>", "<C-w>w")

vim.cmd([[cnoreabbrev wq; wq]])
vim.cmd([[cnoreabbrev w; w]])
