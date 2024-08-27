-- initializes lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local status, lazy = pcall(require, "lazy")
if not status then
	print("[error] no lazy to be found, but is required to load plugins")
	return
end

-- helper function for conform.nvim
local function eval_parser(self, ctx)
	local ft = vim.bo[ctx.buf].filetype
	local ext = vim.fn.fnamemodify(ctx.filename, ":e")
	local options = self.options
	local parser = options
		and ((options.ft_parsers and options.ft_parsers[ft]) or (options.ext_parsers and options.ext_parsers[ext]))
	if parser then
		return { "--parser", parser }
	end
end

lazy.setup({
	-- make the background disappear
	{
		"xiyaowong/transparent.nvim",
		opts = {
			extra_groups = {
				"Normal",
				"NormalFloat",
			},
		},
	},
	-- create a pair for ", ' and ` automatically
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },

	-- syntax highlighting
	{ "https://github.com/nvim-treesitter/nvim-treesitter", highlight = {
		enable = true,
	} },

	-- colorscheme that actually looks good
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("kanagawa")
		end,
	},

	-- highlight todos and fixmes
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- display modifications made in git
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- file switching, string grepping and diagnostic listing, basically
	{
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
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			local km = vim.keymap

			-- navigate the list of keymaps
			km.set("n", "<leader>sk", builtin.keymaps)
			-- switch between files
			km.set("n", "<leader>ff", builtin.find_files)
			-- all options in one, basically
			km.set("n", "<leader>ss", builtin.builtin)
			-- grep string
			km.set("n", "<leader>sw", builtin.grep_string)
			-- grep across all files
			km.set("n", "<leader>fs", builtin.live_grep)
			-- list all diagnostics
			km.set("n", "<leader>sd", builtin.diagnostics)
			-- get the last buffer back
			km.set("n", "<leader>sr", builtin.resume)
			-- open history
			km.set("n", "<leader>s.", builtin.oldfiles)
			-- list all open buffers
			km.set("n", "<leader><leader>", builtin.buffers)

			-- glorified and fuzzy /
			km.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end)

			-- glorified and fuzzy /, but for a bunch of files
			km.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end)
		end,
	},

	-- sane default configs for a lot of lsps
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			{ "j-hui/fidget.nvim", opts = {} },

			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-map-telescope", { clear = true }),
				callback = function(event)
					local map = function(keys, func)
						vim.keymap.set("n", keys, func, { buffer = event.buf })
					end

					-- go to definition
					map("gd", require("telescope.builtin").lsp_definitions)
					-- go to references
					map("gr", require("telescope.builtin").lsp_references)
					-- go to implementation
					map("gI", require("telescope.builtin").lsp_implementations)
					-- go to type definition
					map("<leader>D", require("telescope.builtin").lsp_type_definitions)
					-- go to declaration
					map("gD", vim.lsp.buf.declaration)
					-- rename a variable
					map("<leader>rn", vim.lsp.buf.rename)
					-- list code actions
					map("<leader>ca", vim.lsp.buf.code_action)
					-- hover definition
					map("K", vim.lsp.buf.hover)

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end)
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				-- c
				clangd = {
					-- do not run on .proto files
					filetypes = { "c", "cpp" },
				},
				-- go
				gopls = {},
				-- lua
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				-- templ
				templ = {},
				-- htmx
				htmx = {},
				-- js/ts
				tsserver = {},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			-- add formatters
			vim.list_extend(ensure_installed, {
				-- lua
				"stylua",
				-- go
				"gofumpt",
				-- js and a whole bunch of stuff
				"prettier",
				-- python
				"black",
				-- c
				"clang-format",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	-- formatting on save
	{
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
	},

	-- snippets
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
			"saadparwaiz1/cmp_luasnip",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					["<Enter>"] = cmp.mapping.confirm({ select = true }),

					["<C-Space>"] = cmp.mapping.complete({}),

					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
})

-- addition prettier configuration for yaml files
require("conform").formatters.prettierv2 = function(bufnr)
	return {
		command = "prettier",
		args = function(self, ctx)
			return eval_parser(self, ctx) or { "--stdin-filepath", "$FILENAME" }
		end,
		cwd = require("conform.util").root_file({
			".prettierrc",
			".prettierrc.json",
			".prettierrc.yml",
			".prettierrc.yaml",
			".prettierrc.json5",
			".prettierrc.js",
			".prettierrc.cjs",
			".prettierrc.mjs",
			".prettierrc.toml",
			"prettier.config.js",
			"prettier.config.cjs",
			"prettier.config.mjs",
			"package.json",
		}),
		stdin = true,
	}
end
