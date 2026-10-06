return {
	"A7Lavinraj/fyler.nvim",
	dependencies = { "nvim-mini/mini.icons" },
	branch = "stable",
	keys = {
		{
			"<leader>e",
			function()
				require("fyler").open()
			end,
			desc = "File explorer",
		},
	},
	config = function()
		require("config.fyler")
	end,
}
