-- 補完 --
-- nvim-cmp から blink.cmp に移行した。
-- cmp-nvim-lsp / cmp-buffer / cmp-path / cmp-calc / cmp-nvim-lua /
-- cmp-nvim-lsp-signature-help / cmp_luasnip は blink の組み込み機能で賄えるため削除。

return {
  {
    'saghen/blink.cmp',
    dependencies = { 'L3MON4D3/LuaSnip' },
    -- リリースタグを使うと fuzzy matcher のビルド済みバイナリ
    -- (sha256 検証付き) が取得される
    version = '1.*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },

      -- nvim-cmp 時代のキーバインドを踏襲する
      keymap = {
        preset = 'none',
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<Tab>'] = { 'accept', 'fallback' },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          -- nvim-cmp の keyword_length = 2 相当
          snippets = { min_keyword_length = 2 },
          buffer = { min_keyword_length = 2 },
        },
      },

      -- cmp-nvim-lsp-signature-help の代替 (blink 組み込み)
      signature = { enabled = true },

      completion = {
        documentation = { auto_show = true },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
