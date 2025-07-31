local M = {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify") 
		notify.setup({
			max_width = 50,
			stages = "static",
			render = "minimal"
		})
		vim.notify = notify
	end
}

return M
