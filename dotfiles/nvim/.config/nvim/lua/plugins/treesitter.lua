return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    require('nvim-treesitter.configs').setup({
      hightlight = { enable = true, },
      indent = { enable = true },
      auto_install = true,
    })
  end,
}
