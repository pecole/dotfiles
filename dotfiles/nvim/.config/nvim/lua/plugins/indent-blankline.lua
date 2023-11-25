-- インデント可視化 --

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufRead', 'BufNewFile' },
  opts = {},
  config = function()
    require("ibl").setup()
  end
}
