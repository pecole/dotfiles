-- =============================================================================
-- 編集を助ける小さなプラグイン
--
--   tree-sitter-manager … 構文解析器を管理する (色分けの土台)
--   nvim-autopairs      … 括弧やクォートを自動で閉じる
--   nvim-ts-autotag     … HTML/XML のタグを自動で閉じる
--   vimdoc-ja           … ヘルプの日本語訳
--
-- ※ コメントアウト(gc / gcc)は Neovim 0.10 以降の標準機能で使えるため、
--    以前入れていた Comment.nvim は削除した
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- tree-sitter-manager — 構文に沿った色分けのための解析器を管理する
  --
  -- tree-sitter は「プログラムの構造を解析する仕組み」で、これがあると
  -- 単語の見た目ではなく文法にもとづいて色を付けられる。
  -- 言語ごとに解析器が必要で、このプラグインがその導入を受け持つ
  -- ---------------------------------------------------------------------------
  {
    'romus204/tree-sitter-manager.nvim',

    -- 色分けも自動インストールも、ファイル種別が決まったあとに動く。
    -- そのためファイルを開くタイミングで読み込めば間に合う
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'TSManager', 'TSInstall', 'TSUpdate', 'TSUninstall' },

    config = function()
      require('tree-sitter-manager').setup({
        -- 最初から入れておく解析器
        ensure_installed = { 'lua', 'bash', 'awk', 'json', 'diff' },

        -- 未対応の言語のファイルを開いたら、その解析器を自動で入れる。
        -- 取得元はプラグインが持つ一覧に書かれた、固定のバージョン
        auto_install = true,
      })
    end,
  },

  -- ---------------------------------------------------------------------------
  -- nvim-autopairs — ( を打つと ) が自動で入る
  -- ---------------------------------------------------------------------------
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',   -- 文字を打ち始めたときに読み込む
    config = true,           -- 既定の設定で setup する
  },

  -- ---------------------------------------------------------------------------
  -- nvim-ts-autotag — <div> と打つと </div> が自動で入る
  -- ---------------------------------------------------------------------------
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- ---------------------------------------------------------------------------
  -- vimdoc-ja — :help を日本語で読めるようにする
  -- ---------------------------------------------------------------------------
  {
    'vim-jp/vimdoc-ja',

    -- コマンド欄で h を打ったとき(= :help を打とうとしたとき)に読み込む
    keys = {
      { 'h', mode = 'c' },
    },

    init = function()
      -- ここは不具合の回避策。
      --
      -- vimdoc-ja はヘルプの索引ファイル(doc/tags-ja)をリポジトリに含んでいる。
      -- ところが lazy.nvim は更新のたびに索引を作り直すため、リポジトリの
      -- 中身が書き換わった状態になり、次回の更新(git checkout)が失敗する。
      --
      -- そこで更新処理が始まる直前に、索引を元の状態へ戻しておく。
      -- skip-worktree が付いていると checkout が効かないので先に外す
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'LazyUpdatePre', 'LazySyncPre', 'LazyRestorePre' },
        callback = function()
          local dir = vim.fn.stdpath('data') .. '/lazy/vimdoc-ja'

          -- まだ入っていなければ何もしない
          if not vim.uv.fs_stat(dir .. '/.git') then
            return
          end

          vim.system({ 'git', '-C', dir, 'update-index',
            '--no-skip-worktree', 'doc/tags-ja' }):wait()
          vim.system({ 'git', '-C', dir, 'checkout', '--', 'doc/tags-ja' }):wait()
        end,
      })
    end,
  },
}
