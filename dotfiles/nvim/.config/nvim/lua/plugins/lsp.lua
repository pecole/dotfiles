-- =============================================================================
-- LSP — その言語を理解して、補完・エラー表示・定義ジャンプを提供する仕組み
--
-- 3つのプラグインが役割分担している:
--   mason.nvim           … 言語サーバーを見つけて自動でインストールする
--   nvim-lspconfig       … 言語サーバーごとの起動設定を持っている
--   mason-lspconfig.nvim … 上の2つをつなぐ
--
-- 実際のキー割り当ては keymaps.lua の LspAttach のところにある。
-- =============================================================================

return {
  'mason-org/mason-lspconfig.nvim',

  dependencies = {
    { 'mason-org/mason.nvim', config = true },   -- config = true は「既定の設定で setup する」
    { 'neovim/nvim-lspconfig' },
  },

  -- ファイルを開くときに読み込む
  event = { 'BufReadPre', 'BufNewFile' },

  config = true,
}
