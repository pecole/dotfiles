-- タブ、bufferを表示するプラグイン

return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  lazy = false,
  init = function() vim.g.barbar_auto_setup = false end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
  config = function()
    require('barbar').setup(

    )
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', '<leader>j', '<Cmd>BufferPrevious<CR>', opts) --<leader>+jで前のBufferに移動
    map('n', '<leader>k', '<Cmd>BufferNext<CR>', opts)  --<leader>+kで次のBufferに移動
    -- Close buffer
    map('n', '<leader>e', '<Cmd>BufferClose<CR>', opts) --<leader>+eでBufferを削除
  end
}
