return {
	settings = {
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
		},
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			dotnet_enable_inlay_hints_for_parameters = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
			dotnet_enable_tests_code_lens = true,
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		},
	},
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
}
