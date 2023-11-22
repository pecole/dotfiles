local options = {
  -- エンコーディング
  encoding = "utf-8",
  fileencoding = "utf-8",
  -- バックアップ
  backup = false,
  swapfile = false,
  -- 補完
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  -- 検索
  hlsearch = true,
  ignorecase = true,
  smartcase = true,
  incsearch = true,
  -- マウス操作
  mouse = "a",
  -- タブ、インデント
  tabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  smartindent = true,
  -- オンの時、ウィンドウを横分割すると新しいウインドウはカレントウインドウの下に開かれる
  splitbelow = false,
  -- オンの時、ウインドウを縦分割すると新しいウインドウはカレントウインドウの右に開かれる
  splitright = false,
  -- ヘルプの言語
  helplang = 'ja',
  -- 不可視文字化可視化
  list = true,
  listchars = { tab = '>>', trail = '-', nbsp = '+' },
  -- 行番号
  number = true,
  -- ステータスライン
  showmode = false,
  showtabline = 2,
  -- ハイライト
  cursorline = true,
  cursorcolumn = false,
  background = "dark",
  -- クリップボード共有
  clipboard = "unnamedplus",
  -- コマンドラインの行数
  cmdheight = 2,
  -- ウインドウのタイトル
  title = true,
  -- 相対行番号
  relativenumber = false,
  -- 行番号に使われる桁数
  numberwidth = 4,
  -- 目印用の桁をどう表示するか
  signcolumn = "yes",
  -- 行の折返し
  wrap = false,
  -- コマンドラインの補完指定
  wildoptions = "pum",
  -- 補完の透過
  pumblend = 5,
  -- カーソルの上下に確保する表示行
  scrolloff = 8,
  -- フォント
  guifont = "monospace:h17",
  -- ポップアップメニューの高さ
  pumheight = 10,
  -- ターミナルで使うGUIカラー
  termguicolors = true,
  -- 入力をタイムアウトするミリ秒
  timeoutlen = 300,
  -- undo情報をファイルに保存
  undofile = true,
  -- スワップファイル更新までの時間
  updatetime = 300,
  -- 上書きする時バックアップを作成するか
  writebackup = false,
  -- 外部プログラム使用時のシェル
  shell = "zsh",
  -- 指定のパターンに合致するファイルはバックアップしない
  backupskip = { "/tmp/*", "/private/tmp/*" },
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]]) -- TODO: this doesn't seem to work

