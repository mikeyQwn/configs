-- neovim options that can be safely used without any plugins installed

-- leader remap to [Space]
vim.g.mapleader = " "
-- local leader remap. it is used for mappings local to a buffer
vim.g.maplocalleader = " "

-- shows line numbers relative to the cursor
vim.opt.relativenumber = true
-- shows current line number instead of distance to it
vim.opt.number = true

-- sets the system clipboard as neovim yank register
vim.opt.clipboard = "unnamedplus"

-- creates a file that keeps the undos even after buffer closes
vim.opt.undofile = true

-- ignores the casing in searches
vim.opt.ignorecase = true
-- does not ignore the casing if the search contains capital letter
vim.opt.smartcase = true

-- makes update before applying a command a fair bit faster
vim.opt.updatetime = 250

-- shows s/ changes in a little buffer below
vim.opt.inccommand = "split"

-- sane defaults for tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- appends `shiftwidth` number of spaces in place of a tab
vim.opt.smarttab = true

-- keeps the cursor not entirely at the bottom
vim.opt.scrolloff = 5

-- highlights search results
vim.opt.hlsearch = true

-- prevent the layout from shifting when diagnostics pop up
vim.opt.signcolumn = "yes"
