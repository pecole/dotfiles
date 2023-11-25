return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd [[colorscheme tokyonight]]
    require("tokyonight").setup({
      style = "storm",
      transparent = false,
      commentStyle = "italic",
      darkSidebar = true,
      darkFloat = true,
      colors = { hint = "orange", error = "#ff0000" },
    })
  end
}
