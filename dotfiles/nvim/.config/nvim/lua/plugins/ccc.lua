-- カラーピッカー --

-- set ermguicolors to enable highlight groups
vim.opt.termguicolors = true

return {
  'uga-rosa/ccc.nvim',
  cmd = { 'CccPick' },
  ft = { 'lua', 'css', 'scss', 'html' },
  config = function()
    vim.opt.termguicolors = true
    require('ccc').setup({
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    })
  end
}
