-- =============================================================================
-- キーの割り当て
--
-- vim.keymap.set(モード, 押すキー, 実行する内容, オプション) の形で書く。
--
-- モードの記号:
--   'n' … ノーマルモード (文字を打つのではなく操作をするモード)
--   'i' … 挿入モード     (文字を打つモード)
--   'v' … ビジュアルモード (範囲を選択しているモード)
--   't' … ターミナルモード (:terminal でシェルを開いているとき)
--   ''  … n / v / オペレータ待ち の3つをまとめて指定
--
-- <Leader> は「自分用のキーの入り口」。ここではスペースキーにしている。
-- 例えば <Leader>cl は「スペース → c → l」と順に押すという意味。
--
-- プラグインごとのキー割り当ては plugins/ 以下の各ファイルにある。
-- =============================================================================

-- noremap … 割り当て先がさらに別の割り当てを持っていても展開しない(暴走防止)
-- silent  … 実行時にコマンド欄へ内容を表示しない
local opts = { noremap = true, silent = true }


-- -----------------------------------------------------------------------------
-- Leader キーの設定
--
-- スペース本来の動作(カーソルを右へ)を打ち消してから、Leader に割り当てる。
-- ※ Leader を使う割り当てより先に書く必要がある
-- -----------------------------------------------------------------------------
vim.keymap.set('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- -----------------------------------------------------------------------------
-- ウィンドウの移動 (画面を分割しているとき)
--
-- 本来は Ctrl-w → h のように2回押す必要があるが、Ctrl-h だけで動くようにする
-- -----------------------------------------------------------------------------
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)   -- 左のウィンドウへ
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)   -- 下のウィンドウへ
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)   -- 上のウィンドウへ
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)   -- 右のウィンドウへ


-- -----------------------------------------------------------------------------
-- 編集まわり
-- -----------------------------------------------------------------------------
-- x (1文字削除) でコピー内容を上書きしないようにする。
-- "_ は「捨てる置き場」を指定する書き方
vim.keymap.set('n', 'x', '"_x', opts)

-- Y を「カーソルから行末までコピー」にする (本来は行全体のコピー)。
-- D や C が行末までなので、それに揃える
vim.keymap.set('n', 'Y', 'y$', opts)

-- Esc を2回押すと検索語の強調表示を消す
vim.keymap.set('n', '<Esc><Esc>', ':<C-u>set nohlsearch<Return>', opts)


-- -----------------------------------------------------------------------------
-- ビジュアルモード (範囲選択中)
-- -----------------------------------------------------------------------------
-- 字下げしても選択が解除されないようにする (gv = 直前の選択を復元)
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- 選択中にもう一度 v を押すと行末まで選択を広げる
-- ($ は行末、h で1文字戻すのは改行文字を含めないため)
vim.keymap.set('v', 'v', '$h', opts)


-- -----------------------------------------------------------------------------
-- ターミナルモード
-- -----------------------------------------------------------------------------
-- Esc でターミナルの操作から抜けて、画面を移動できるようにする
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)


-- -----------------------------------------------------------------------------
-- AI に質問するとき用 (コマンドの中身は commands.lua)
-- -----------------------------------------------------------------------------
vim.keymap.set('n', '<Leader>cl', '<cmd>CpCurrentLine<cr>', opts)   -- 現在行の場所をコピー
vim.keymap.set('v', '<Leader>ch', '<cmd>CpSelectedLines<cr>', opts) -- 選択範囲の場所をコピー
vim.keymap.set('n', '<Leader>ck', '<cmd>CpError<cr>', opts)         -- エラー内容をコピー


-- -----------------------------------------------------------------------------
-- エラー・警告の表示 (LSP を使っていなくても常に有効)
-- -----------------------------------------------------------------------------
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float,
  { desc = 'Diagnostic - 内容をその場に表示' })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { desc = 'Diagnostic - 前のエラーへ' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { desc = 'Diagnostic - 次のエラーへ' })
vim.keymap.set('n', '<space>ll', vim.diagnostic.setloclist,
  { desc = 'Diagnostic - 一覧を出す' })


-- -----------------------------------------------------------------------------
-- LSP の機能 (定義へ移動、名前の変更など)
--
-- LSP は「その言語を理解して補完やエラー表示をしてくれる外部プログラム」。
-- 言語ごとに用意されていて、対応するファイルを開いたときだけ動く。
--
-- そのためキーの割り当ても、LSP がそのファイルに接続したとき(LspAttach)に
-- 「そのファイルの中でだけ有効」な形で行う。
-- buffer = ev.buf の指定がその「このファイルの中だけ」という意味。
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Ctrl-x Ctrl-o の標準の補完でも LSP の候補を使えるようにする
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- このファイルの中だけで有効なキーを割り当てるための小さな道具
    local function map(key, action, description)
      vim.keymap.set('n', key, action, { buffer = ev.buf, desc = description })
    end

    -- 移動
    map('gd', vim.lsp.buf.definition,      'Buffer - 定義へ移動')
    map('gD', vim.lsp.buf.declaration,     'Buffer - 宣言へ移動')
    map('gi', vim.lsp.buf.implementation,  'Buffer - 実装へ移動')
    map('gr', vim.lsp.buf.references,      'Buffer - 使われている場所の一覧')
    map('<space>D', vim.lsp.buf.type_definition, 'Buffer - 型の定義へ移動')

    -- 情報の表示
    map('gk', vim.lsp.buf.hover,          'Buffer - 説明を表示')
    map('gh', vim.lsp.buf.signature_help, 'Buffer - 引数の説明を表示')

    -- 書き換え
    map('<space>rn', vim.lsp.buf.rename,      'Buffer - 名前を変更')
    map('<space>ca', vim.lsp.buf.code_action, 'Buffer - 修正候補を出す')
    map('<space>f', function()
      vim.lsp.buf.format { async = true }   -- async = 整形の完了を待たない
    end, 'Buffer - 整形する')

    -- ワークスペース (LSP が見ている対象フォルダ) の管理
    map('<space>wa', vim.lsp.buf.add_workspace_folder,    'Buffer - 対象フォルダを追加')
    map('<space>wr', vim.lsp.buf.remove_workspace_folder, 'Buffer - 対象フォルダを削除')
    map('<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'Buffer - 対象フォルダの一覧')
  end,
})
