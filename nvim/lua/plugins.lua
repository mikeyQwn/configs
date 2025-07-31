local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local status, lazy = pcall(require, "lazy")
if not status then
	print("[e] no lazy to be found, but is required to load plugins")
	return
end

local plugins = {
	{ name = "nvim_notify", enabled = true },
	{ name = "autopairs", enabled = true },
	{ name = "telescope", enabled = true },
	{ name = "nvim_cmp", enabled = true },
	{ name = "lspconfig", enabled = true },
	{ name = "conform", enabled = true },
	{ name = "transparent_nvim", enabled = true },
}

local enabled = {}
local deferred_warnings = {}

for _, plugin in ipairs(plugins) do
	if not plugin.enabled then
		goto continue
	end

	local ok, plugin_source = xpcall(function()
		return require("plugins/" .. plugin.name)
	end, function(err)
		table.insert(deferred_warnings, string.format("[e] unable to find plugin '%s' source: %s", plugin.name, err))
	end)

	if not ok then
		goto continue
	end

	table.insert(enabled, plugin_source)

	::continue::
end

lazy.setup(enabled)

vim.schedule(function()
	for _, warning in ipairs(deferred_warnings) do
		vim.notify(warning, vim.log.levels.WARN)
	end
end)
