return {
  -- コードハイライト --
  {
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
  },
  -- 自動括弧閉じ --
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  -- HTML, XMLのタグ自動閉じ --
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  -- コメントアウト --
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('Comment').setup()
    end
  },
  -- vim help 日本語訳 --
  {
    'vim-jp/vimdoc-ja',
    keys = {
      { 'h', mode = 'c' },
    }
  },
}
