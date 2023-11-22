-- telescope --

return {
  'nvim-telescope/telescope-file-browser.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-frecency.nvim'
  },
  keys = {
    { '<C-p>', ':Telescope find_files<CR>',   mode = 'n' },
    { '<C-g>', ':Telescope live_grep<CR>',    mode = 'n' },
    { '<C-f>', ':Telescope frecency<CR>',     mode = 'n' },
    { '<C-b>', ':Telescope file_browser<CR>', mode = 'n' }
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup()
    telescope.load_extension('frecency')
  end
}
