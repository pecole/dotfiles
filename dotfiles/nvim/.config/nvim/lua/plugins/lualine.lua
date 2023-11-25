-- ステータスバー --
return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  event = { 'BufNewFile', 'BufRead' },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require('lualine').setup({
      theme = 'tokyonight',
    })
  end
}
