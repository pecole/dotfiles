return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = 'VeryLazy',
  config = function()
    local config = require('nvim-treesitter.configs')
    config.setup({
      ensure_installed = { "lua", "bash", "awk", "json", "diff" },
      sync_install = true,
      auto_install = true,

      highlight = { enable = true },
      indent = { enable = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    })
  end,
}
