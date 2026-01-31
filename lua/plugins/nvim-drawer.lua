return {
	{
		'mikew/nvim-drawer',
		lazy = false,
		opts = {},
		config = function(_, opts)
			local drawer = require('nvim-drawer')
			drawer.setup(opts)
		end
	}
}
