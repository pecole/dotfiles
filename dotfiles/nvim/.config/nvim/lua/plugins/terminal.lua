-- =============================================================================
-- ターミナル — Neovim を閉じずにシェルや lazygit を開く
--
--   <leader>tt … シェルを画面中央に開く / 閉じる
--   <leader>tg … lazygit (gitの操作画面) を開く / 閉じる
--
-- どちらも同じキーで開閉できる (トグル)。
-- ターミナルの中にいるときも同じキーで閉じられるよう、
-- ノーマルモード 'n' とターミナルモード 't' の両方に割り当てている。
-- =============================================================================

-- 開いたターミナルをここに覚えておく。
-- 2回目以降は同じものを開き直すので、中の状態が残る
local terminals = {}


-- 「開閉する関数」を作って返す
--
-- プラグインが読み込まれる前にこのファイルは評価されるので、
-- require はキーを押した時点(=関数の中)で行う必要がある
local function toggle(name, opts)
  return function()
    if not terminals[name] then
      terminals[name] = require('toggleterm.terminal').Terminal:new(opts)
    end
    terminals[name]:toggle()
  end
end


-- direction = 'float' … 画面中央に浮かせて表示する
-- hidden = true       … 起動時には開かず、キーを押すまで隠しておく
local open_shell = toggle('float', { direction = 'float', hidden = true })
local open_lazygit = toggle('lazygit', { cmd = 'lazygit', direction = 'float', hidden = true })


return {
  'akinsho/toggleterm.nvim',
  version = '*',   -- 最新のリリース版を使う
  opts = {},

  keys = {
    { '<leader>tt', open_shell,   mode = { 'n', 't' }, desc = 'ToggleTerm - シェルを開閉' },
    { '<leader>tg', open_lazygit, mode = { 'n', 't' }, desc = 'ToggleTerm - lazygitを開閉' },
  },
}
