local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup('MyAutocmds', { clear = true })

-- 保存時に行末の空白を削除する
-- markdown の行末2スペースなど意味を持つものは対象外にする
local trim_ignore = { markdown = true, diff = true, gitcommit = true, gitrebase = true }
autocmd('BufWritePre', {
  group = group,
  callback = function(args)
    if trim_ignore[vim.bo[args.buf].filetype] then
      return
    end
    -- keeppatterns で検索履歴を汚さず、winsaveview でカーソル位置を保つ
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- 改行時にコメントを自動継続しない
-- ftplugin が formatoptions を上書きするため FileType の後に打ち消す
autocmd('FileType', {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- ファイルを開いたときに前回のカーソル位置を復元する
autocmd('BufReadPost', {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.cmd('normal! zv')
    end
  end,
})

-- Goファイルは保存時に import を整理してからフォーマットする
autocmd('BufWritePre', {
  group = group,
  pattern = '*.go',
  callback = function(args)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, method = 'textDocument/codeAction' })) do
      -- make_range_params は nvim 0.11 以降 position_encoding が必須
      local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
      params.context = { only = { 'source.organizeImports' }, diagnostics = {} }

      -- 既定の1000msだとリポジトリによっては足りず、2回保存が必要になることがある
      local res = client:request_sync('textDocument/codeAction', params, 3000, args.buf)
      for _, r in pairs(res and res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})
