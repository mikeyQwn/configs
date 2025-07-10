local km = vim.keymap

-- clears search highlight
km.set("n", "<leader>cs", "<cmd>nohlsearch<CR>")

-- open the previous diagnostic
km.set("n", "[d", vim.diagnostic.goto_prev)
-- open the next diagnostic
km.set("n", "]d", vim.diagnostic.goto_next)
-- opens diagnostic floating window
km.set("n", "<leader>e", vim.diagnostic.open_float)
-- opens quickfix list floating window
km.set("n", "<leader>q", vim.diagnostic.setloclist)

-- move around split windows using default neovim keymaps
km.set("n", "<C-h>", "<C-w><C-h>")
km.set("n", "<C-l>", "<C-w><C-l>")
km.set("n", "<C-j>", "<C-w><C-j>")
km.set("n", "<C-k>", "<C-w><C-k>")

km.set("n", "<C-w>", "<C-w>w") -- toggle between panes

-- golang-specific much-needed maps
km.set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
km.set("n", "<leader>er", "oif err != nil {<CR>}<Esc>Oreturn nil, err<Esc>")
km.set("n", "<leader>ef", "oif err != nil {<CR>}<Esc>Olog.Fatal(err)<Esc>")

-- prevent fatfingering
vim.cmd([[cnoreabbrev wq; wq]])
vim.cmd([[cnoreabbrev w; w]])
