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
  config = function()
    require('barbar').setup(

    )
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- Move to previous/next
    map('n', '<leader>j', '<Cmd>BufferPrevious<CR>', opts) --<leader>+jで前のBufferに移動
    map('n', '<leader>k', '<Cmd>BufferNext<CR>', opts)  --<leader>+kで次のBufferに移動
    -- Close buffer
    map('n', '<leader>d', '<Cmd>BufferClose<CR>', opts) --<leader>+eでBufferを削除
    map('n', '<leader>q', '<Cmd>BufferCloseAllButCurrent<CR>', opts) --<leader>+qで現在のBuffer以外を削除
  end
}
