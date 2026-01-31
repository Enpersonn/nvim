return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function()
      vim.g.treesitter_compilers = { "zig" }
    end,
    config = function()
      require("nvim-treesitter.install").compilers = vim.g.treesitter_compilers

      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "javascript", "typescript", "tsx" },
        highlight = { enable = true },
      })
    end,
  },
}
