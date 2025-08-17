local lsps = {
	clangd = {
		filetypes = { "c", "cpp" },
	},
	gopls = {},
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	templ = {},
}

local installed_lsps = {
	"rust_analyzer",
}

local formatters = {
	"stylua",
	"gofumpt",
	"black",
	"clang-format",
}

local onLspAttach = {
	group = vim.api.nvim_create_augroup("lsp-map-telescope", { clear = true }),
	callback = function(event)
		local map = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = event.buf })
		end

		local ok, builtin = pcall(require, "telescope.builtin")
		if ok then
			map("gd", builtin.lsp_definitions)
			map("gr", builtin.lsp_references)
			map("gI", builtin.lsp_implementations)
			map("<leader>D", builtin.lsp_type_definitions)
		end
		map("gD", vim.lsp.buf.declaration)
		map("<leader>rn", vim.lsp.buf.rename)
		map("<leader>ca", vim.lsp.buf.code_action)
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
}

local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ "j-hui/fidget.nvim", opts = {} },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", onLspAttach)

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
		end

		local ok, mason = pcall(require, "mason")
		if not ok then
			vim.notify("[LSP Setup] Failed to load mason", vim.log.levels.WARN)
		else
			mason.setup()
		end

		local ensure_installed = vim.tbl_keys(lsps or {})
		vim.list_extend(ensure_installed, formatters or {})

		local ok, mason_tool_installer = pcall(require, "mason-tool-installer")
		if not ok then
			vim.notify("[LSP Setup] Failed to load mason-tool-installer", vim.log.levels.WARN)
		else
			mason_tool_installer.setup({
				ensure_installed = ensure_installed,
			})
		end

		local install_server = function(server_name)
			local ok, lspconfig = pcall(require, "lspconfig")
			if not ok then
				vim.notify("[LSP Setup] Failed to load lspconfig for " .. server_name, vim.log.levels.WARN)
				return
			end

			local server = lsps[server_name] or {}
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			lspconfig[server_name].setup(server)
		end

		local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
		if not ok then
			vim.notify("[LSP Setup] Failed to load mason-lspconfig", vim.log.levels.WARN)
		else
			mason_lspconfig.setup({
				handlers = { install_server },
			})
		end

		for _, lsp in ipairs(installed_lsps) do
			local ok, _ = pcall(install_server, lsp)
			if not ok then
				vim.notify("[LSP Setup] Failed to setup server: " .. lsp, vim.log.levels.WARN)
			end
		end
	end,
}

return M
