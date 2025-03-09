-- sane default configs for a lot of lsps

-- servers installed by default
local lsps = {
	clangd = {
		-- do not run on .proto files
		filetypes = { "c", "cpp" },
	}, -- c
	gopls = {}, -- go
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	}, -- lua
	templ = {}, -- templ
	htmx = {}, -- htmx
	ts_ls = {}, -- js/ts
}

local formatters = {
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
}

local M = {
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

		-- TODO: Fix this and add to config
		-- local rust_config = { checkOnSave = { enable = false } }
		-- rust_analyzer = {
		-- 	settings = { ["rust-analyzer"] = rust_config },
		-- },

		require("mason").setup()

		local ensure_installed = vim.tbl_keys(lsps or {})
		-- add formatters
		vim.list_extend(ensure_installed, formatters)

		require("mason-tool-installer").setup({
			ensure_installed = ensure_installed,
		})

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = lsps[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

return M
