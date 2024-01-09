return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  lazy = false,
  config = function()
    require('catppuccin').setup({
      transparent_background = true,
    })
    vim.cmd.colorscheme('catppuccin-mocha')
    vim.cmd("highlight TelescopeSelection cterm=bold gui=bold guifg=#a6e3a1 guibg=#181825")
  end
}
