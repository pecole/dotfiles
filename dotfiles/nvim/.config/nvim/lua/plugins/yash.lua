-- カラースキーム --
return
{
  'kihachi2000/yash.nvim',
  event = 'VimEnter',
  config = function()
    vim.opt.termguicolors = true
    vim.cmd('colorscheme yash')
  end
}
