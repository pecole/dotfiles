return {
  -- コードハイライト --
  {
    'romus204/tree-sitter-manager.nvim',
    lazy = false,
    config = function()
      require('tree-sitter-manager').setup({
        ensure_installed = { "lua", "bash", "awk", "json", "diff" },
        auto_install = true,
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
