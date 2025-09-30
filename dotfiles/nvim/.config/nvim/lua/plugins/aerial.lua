-- 関数一覧を表示するプラグイン ---

return {
  'stevearc/aerial.nvim',
  opts = {},
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require("aerial").setup({
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        local map = vim.keymap.set
        local opts = { buffer = bufnr }
        -- Jump forwards/backwards with '{' and '}'
        map("n", "{", "<cmd>AerialPrev<CR>", opts)
        map("n", "}", "<cmd>AerialNext<CR>", opts)
      end,
    })
    -- You probably also want to set a keymap to toggle aerial
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
  end
}
