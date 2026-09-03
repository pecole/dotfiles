-- キーマップは keymaps.lua の LspAttach 側で定義している
return {
  'mason-org/mason-lspconfig.nvim',
  dependencies = {
    { 'mason-org/mason.nvim',   config = true },
    { 'neovim/nvim-lspconfig' },
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = true,
}
