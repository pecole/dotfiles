return {
  'mason-org/mason-lspconfig.nvim',
  dependencies = {
    { 'mason-org/mason.nvim',           config = true },
    { 'neovim/nvim-lspconfig' },
    { 'jose-elias-alvarez/null-ls.nvim' },
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = true,
  key = {
    { "<C-space>", "<cmd>lua vim.lsp.completion.get()  <CR>", mode = "i" },
    { "gh",        "<cmd>lua vim.lsp.buf.hover()       <CR>" },
    { "gd",        "<cmd>lua vim.lsp.buf.definition()  <CR>" },
    { "gD",        "<cmd>lua vim.lsp.buf.declaration() <CR>" },
  }
}
