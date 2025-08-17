local modules = { "options", "keymaps", "plugins" }

for _, module in ipairs(modules) do
	xpcall(function()
		require(module)
	end, function(error)
		print(string.format("unable to load module %s: %s", module, error))
	end)
end
