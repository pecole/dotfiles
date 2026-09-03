-- =============================================================================
-- 入力補完 (blink.cmp)
--
-- 文字を打つと候補の一覧が出て、Tab で確定できる。
-- 以前は nvim-cmp を使っていたが、候補の取得元(LSP・スニペットなど)を
-- 別々のプラグインとして入れる必要があった。blink.cmp はそれらを内蔵している。
--
-- キー操作:
--   Ctrl-p / Ctrl-n     候補を上/下に選ぶ
--   Ctrl-d / Ctrl-f     説明文をスクロールする
--   Ctrl-Space          候補を出す / 説明を出す
--   Ctrl-e              候補を閉じる
--   Tab                 選んでいる候補を確定する
-- =============================================================================

return {
  {
    'saghen/blink.cmp',

    -- LuaSnip は「よく書く定型文を短い単語から展開する」プラグイン
    dependencies = { 'L3MON4D3/LuaSnip' },

    -- '1.*' はバージョン1系の最新リリースを使うという指定。
    -- blink.cmp は候補の絞り込みを Rust で書かれた部品で高速に行う。
    -- その部品はリリースごとにビルド済みのものが配布され、
    -- ダウンロード時に中身が正しいか(sha256)を検証している
    version = '1.*',

    -- 文字を打ち始めたとき、またはコマンド欄を開いたときに読み込む
    event = { 'InsertEnter', 'CmdlineEnter' },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- スニペットは LuaSnip のものを使う
      snippets = { preset = 'luasnip' },

      -- キー割り当て。
      -- preset = 'none' で既定の割り当てを使わず、全部自分で決める。
      -- { 'A', 'fallback' } は「Aを試し、できなければ本来の動作をする」
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

      -- 候補をどこから集めるか
      sources = {
        default = {
          'lsp',       -- 言語サーバー(その言語を理解した候補)
          'path',      -- ファイルのパス
          'snippets',  -- 定型文
          'buffer',    -- 今開いているファイルの中に出てくる単語
        },
        providers = {
          -- 2文字打ってから候補を出す。1文字だと候補が多すぎて邪魔になるため
          snippets = { min_keyword_length = 2 },
          buffer = { min_keyword_length = 2 },
        },
      },

      -- 関数を書いているとき、引数の説明を出す
      signature = { enabled = true },

      completion = {
        -- 選んでいる候補の説明を自動で表示する
        documentation = { auto_show = true },
      },
    },

    -- 他の場所から sources.default に追記できるようにする指定
    opts_extend = { 'sources.default' },
  },
}
