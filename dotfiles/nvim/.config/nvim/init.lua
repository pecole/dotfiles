-- =============================================================================
-- Neovim の設定の入り口
--
-- 設定は lua/ フォルダに分けてあり、このファイルは読み込む順番を決めるだけ。
-- require('base') と書くと lua/base.lua が読み込まれる。
--
--   base       … 一番最初に決めておきたいこと (使わない機能を切る等)
--   autocmds   … 「ファイルを保存したとき」などに自動で動く処理
--   options    … 見た目や動作の設定 (行番号を出す、タブ幅など)
--   keymaps    … キーの割り当て
--   commands   … 自作コマンド (:So など)
--   lazy_nvim  … プラグインの管理。plugins/ 以下を読み込む
-- =============================================================================

require('base')
require('autocmds')
require('options')
require('keymaps')
require('commands')
require('lazy_nvim')
