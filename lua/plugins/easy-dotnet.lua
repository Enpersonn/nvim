return {
	"GustavEikaas/easy-dotnet.nvim",
	ft = { "cs", "razor" },
	cmd = "Dotnet",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap",
	},
	keys = {
		{ "<leader>nr", "<cmd>Dotnet run profile default<cr>", desc = ".NET: Run profile" },
		{ "<leader>nd", "<cmd>Dotnet debug profile default<cr>", desc = ".NET: Debug profile" },
		{ "<leader>nb", "<cmd>Dotnet build solution quickfix<cr>", desc = ".NET: Build solution" },
		{ "<leader>nx", "<cmd>Dotnet testrunner<cr>", desc = ".NET: Test runner" },
	},
	config = function()
		require("easy-dotnet").setup({
			picker = "telescope",
			lsp = {
				preload_roslyn = false,
				restart_roslyn_on_branch_change = true,
			},
			test_runner = {
				mappings = {
					run_test_from_buffer = { lhs = "<leader>ntr", desc = ".NET: Run test" },
					run_all_tests_from_buffer = { lhs = "<leader>nta", desc = ".NET: Run file tests" },
					debug_test_from_buffer = { lhs = "<leader>ntd", desc = ".NET: Debug test" },
					peek_stack_trace_from_buffer = { lhs = "<leader>ntp", desc = ".NET: Peek test failure" },
				},
			},
		})
	end,
}
