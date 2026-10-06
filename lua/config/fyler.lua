local fyler = require("fyler")

fyler.setup({
	views = {
		finder = {
			close_on_select = false,

			win = {
				kind = "split_left_most",
				kinds = {
					split_left_most = {
						width = "7%",
					},
				},
			},
		},
	},
	integrations = {
		icons = "mini_icons",
	},
	mappings = {
		n = {
			["g."] = {
				action = "toggle_ui",
				args = { "hidden_items" },
				desc = "Toggle hidden files",
			},
		},
	},
})
