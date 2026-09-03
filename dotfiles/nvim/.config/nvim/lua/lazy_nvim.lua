-- =============================================================================
-- プラグイン管理 (lazy.nvim)
--
-- lazy.nvim は「必要になるまでプラグインを読み込まない」仕組みを持つ管理ツール。
-- 全部を起動時に読み込むと遅くなるので、使うときまで待つことで起動を速くする。
--
-- どのプラグインを入れるかは lua/plugins/ 以下のファイルに書く。
-- 各プラグインでよく使う指定:
--
--   event = 'BufReadPre'  … その出来事が起きたときに読み込む
--   keys  = { '<leader>e' } … そのキーを押したときに読み込む
--   cmd   = { 'Telescope' } … そのコマンドを実行したときに読み込む
--   ft    = { 'lua' }       … その種類のファイルを開いたときに読み込む
--   lazy  = false           … 待たずに起動時から読み込む(配色などに使う)
--
--   opts   = { ... }  … この内容で自動的に setup() を呼んでもらう
--   config = function() ... end … 読み込み時に自分で好きな処理をする
--   dependencies = { ... } … 先に読み込んでおくプラグイン
--
-- 使うバージョンは lazy-lock.json に記録され、git で管理している。
-- 別のマシンでも :Lazy restore で同じ状態を再現できる。
-- =============================================================================

-- lazy.nvim 本体の置き場所
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- 初回だけ、lazy.nvim 自体を GitHub から取ってくる
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',   -- ファイルの中身は必要になるまで取得しない(速い)
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',      -- 安定版を使う
    lazypath,
  })
end

-- Neovim が lua を探す場所の先頭に lazy.nvim を加える
vim.opt.rtp:prepend(lazypath)


local opts = {
  defaults = {
    -- 何も指定していないプラグインは「必要になるまで読み込まない」を既定にする
    lazy = true,
  },

  -- luarocks は Lua のパッケージ管理システム。
  -- それを必要とするプラグインは入れていないので、連携ごと無効にする
  -- (無効にしないと :checkhealth lazy が警告を出し続ける)
  rocks = {
    enabled = false,
  },

  performance = {
    -- 読み込んだ内容を保存しておき、次回の起動を速くする
    cache = {
      enabled = true,
    },
  },
}

-- 'plugins' = lua/plugins/ 以下のファイルを全部読み込む、という意味
require('lazy').setup('plugins', opts)
