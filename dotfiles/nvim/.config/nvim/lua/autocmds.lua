-- =============================================================================
-- 自動で動く処理 (autocmd)
--
-- 「ファイルを保存したとき」「ファイルを開いたとき」のような出来事をきっかけに
-- 自動で実行される処理をまとめる。
--
--   vim.api.nvim_create_autocmd(きっかけ, { 設定 })
--
-- group を指定しておくと、設定を読み直したときに同じ処理が二重に登録されない
-- (clear = true が「同じグループの古い登録を消してから追加する」という意味)
-- =============================================================================

local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup('MyAutocmds', { clear = true })


-- -----------------------------------------------------------------------------
-- 保存するとき、行末の余計な空白を消す
--
-- ただし markdown などは行末の空白に意味があるので対象から外す
-- (markdown では行末の半角スペース2つが改行を表す)
-- -----------------------------------------------------------------------------
local skip_filetypes = {
  markdown = true,
  diff = true,
  gitcommit = true,
  gitrebase = true,
}

autocmd('BufWritePre', {   -- BufWritePre = ファイルを保存する直前
  group = group,
  callback = function(args)
    if skip_filetypes[vim.bo[args.buf].filetype] then
      return
    end

    -- 置換を行うとカーソルが動き、検索履歴も上書きされてしまう。
    -- winsaveview で今の表示位置を覚えておき、あとで戻す。
    -- keeppatterns は「この置換を検索履歴に残さない」という指定
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})


-- -----------------------------------------------------------------------------
-- 改行したときにコメント記号を自動で続けない
--
-- formatoptions の c / r / o がその自動継続の設定。
-- これはファイル種別ごとの標準設定で上書きされてしまうため、
-- 種別が決まった直後(FileType)に打ち消す必要がある
-- -----------------------------------------------------------------------------
autocmd('FileType', {
  group = group,
  callback = function()
    -- opt_local = 今開いているファイルにだけ適用する
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})


-- -----------------------------------------------------------------------------
-- ファイルを開いたとき、前回閉じたときのカーソル位置に戻す
--
-- Neovim は前回の位置を " という印(マーク)に記録している。
-- ただしファイルが短くなっていると存在しない行を指すことがあるので、
-- 行数の範囲内かどうかを確認してから移動する
-- -----------------------------------------------------------------------------
autocmd('BufReadPost', {   -- BufReadPost = ファイルを読み込んだ直後
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local last_line = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= last_line then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)   -- pcall = 失敗しても止まらない
      vim.cmd('normal! zv')                          -- 折りたたまれていたら開く
    end
  end,
})


-- -----------------------------------------------------------------------------
-- Go のファイルを保存するとき、import を整理してから整形する
--
-- 「使っていない import を消す・足りないものを足す」を LSP(gopls)に依頼し、
-- そのあとコード全体を整形する
-- -----------------------------------------------------------------------------
autocmd('BufWritePre', {
  group = group,
  pattern = '*.go',
  callback = function(args)
    -- このファイルに接続していて、修正候補を出せる LSP を探す
    local clients = vim.lsp.get_clients({
      bufnr = args.buf,
      method = 'textDocument/codeAction',
    })

    for _, client in ipairs(clients) do
      -- どの範囲について尋ねるかを組み立てる。
      -- make_range_params は Neovim 0.11 以降、文字数の数え方
      -- (position_encoding) を渡す必要がある
      local range = vim.lsp.util.make_range_params(0, client.offset_encoding)

      ---@type lsp.CodeActionParams
      local params = {
        textDocument = range.textDocument,
        range = range.range,
        -- source.organizeImports = 「import を整理する」という決まった名前
        context = { only = { 'source.organizeImports' }, diagnostics = {} },
      }

      -- LSP に問い合わせて返事を待つ。
      -- 待ち時間の既定値1000msでは足りないことがあるので3000msにしている
      local response = client:request_sync('textDocument/codeAction', params, 3000, args.buf)

      -- 返ってきた修正内容をファイルに適用する
      for _, action in pairs(response and response.result or {}) do
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        end
      end
    end

    -- 整形は保存前に終わっている必要があるので、完了を待つ (async = false)
    vim.lsp.buf.format({ async = false })
  end,
})
