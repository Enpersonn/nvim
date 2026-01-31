require("typescript-tools").setup {
	settings = {
		tsserver_path = nil,
		tsserver_locale = "en",
		disable_member_code_lens = false,
		code_lens = "all",
		tsserver_format_options = {
			insertSpaceAfterCommaDelimiter = true,
			insertSpaceAfterSemicolonInForStatements = true,
			insertSpaceBeforeAndAfterBinaryOperators = true,
			insertSpaceAfterConstructor = true,
			insertSpaceAfterKeywordsInControlFlowStatements = true,
			insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
			insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
			insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = true,
			insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
			insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
			insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = true,
			insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = true,
			insertSpaceAfterTypeAssertion = true,
			insertSpaceBeforeFunctionParenthesis = true,
			placeOpenBraceOnNewLineForFunctions = false,
			placeOpenBraceOnNewLineForControlBlocks = true,
			insertSpaceBeforeTypeAnnotation = true,
			semicolons = "insert",
		},
		tsserver_file_preferences = {
			includeCompletionForModuleExport = true,
			includeCompletionForImportStatements = true,
			includeAutomaticOptionalChainCompletions = true,

			displayPartsForJSDoc = true,

			includeInlayEnumMemeberValueHints = true,
			includeParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayFunctionParameterTypeHints = true,

			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	}
}
