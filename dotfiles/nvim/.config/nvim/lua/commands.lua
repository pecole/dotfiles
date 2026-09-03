-- =============================================================================
-- 自作コマンド
--
-- :So のように、コロンから打って使うコマンドを定義する。
-- AI に質問するときに「どのファイルの何行目か」をコピーするものが多い。
-- =============================================================================

local command = vim.api.nvim_create_user_command


-- -----------------------------------------------------------------------------
-- :So — 設定ファイルを読み直す
--
--   :So              設定ファイル全体 ($MYVIMRC) を読み直す
--   :So ファイル名   指定したファイルを読み直す
-- -----------------------------------------------------------------------------
command('So', function(opts)
  if #opts.fargs > 0 then
    vim.cmd('source ' .. opts.fargs[1])
  else
    vim.cmd('source $MYVIMRC')
  end
end, { nargs = '*' })   -- nargs='*' は「引数は何個でもよい」という意味


-- -----------------------------------------------------------------------------
-- :CpCurrentLine — 今いる場所を「at 12 in path/to/file.lua」の形でコピーする
-- -----------------------------------------------------------------------------
command('CpCurrentLine', function()
  local path = vim.fn.expand('%:p:.')                 -- 今のファイルのパス
  local line = vim.api.nvim_win_get_cursor(0)[1]      -- カーソルのある行番号
  local copied = 'at ' .. line .. ' in ' .. path

  vim.fn.setreg('+', copied)                          -- '+' はクリップボード
  vim.notify('Copied "' .. copied .. '" to the clipboard!')
end, {})


-- -----------------------------------------------------------------------------
-- :CpSelectedLines — 選択した範囲を「at 12-20 in path/to/file.lua」でコピーする
-- -----------------------------------------------------------------------------
command('CpSelectedLines', function()
  local path = vim.fn.expand('%:p:.')

  -- 選択範囲の両端。line('.') はカーソル側、line('v') は反対側
  local first, last = vim.fn.line('.'), vim.fn.line('v')

  -- 下から上に選択した場合は逆になっているので入れ替える
  if first > last then
    first, last = last, first
  end

  local copied = 'at ' .. first .. '-' .. last .. ' in ' .. path
  vim.fn.setreg('+', copied)
  vim.notify('Copied "' .. copied .. '" to the clipboard!')
end, { range = true })   -- range=true は「選択範囲を受け取れる」という意味


-- -----------------------------------------------------------------------------
-- :CpError — カーソル行のエラーを、質問文の形にしてコピーする
-- -----------------------------------------------------------------------------
command('CpError', function()
  -- カーソル行のエラーや警告を取り出す
  -- (lnum は0から数えるので、行番号から1を引く)
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

  if #diagnostics == 0 then
    return vim.notify('No diagnostics')
  end

  local path = vim.fn.expand('%:p:.')
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local copied = 'Do you know why the following error occurs at '
    .. line .. ' in ' .. path .. '?\n\n' .. diagnostics[1].message

  vim.fn.setreg('+', copied)
  vim.notify('Copied error messages to the clipboard!')
end, { range = true })
