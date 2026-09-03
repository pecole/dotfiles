vim.scriptencoding = 'utf-8'

-- remote python plugin は未使用のため python3 provider を無効化する
vim.g.loaded_python3_provider = 0

-- netrw は nvim-tree を使うため無効化する
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- number / termguicolors などの表示系オプションは options.lua に集約している

-- insertモードからnormalモードに切り替えた時にIMEをオフにする
if vim.fn.has('mac') == 1 then
  vim.opt.ttimeoutlen = 1
  vim.api.nvim_create_augroup('MyIMEGroup', {})
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = 'MyIMEGroup',
    pattern = '*',
    callback = function()
      -- os.execute は同期実行でモード切替が詰まるため非同期で投げる
      vim.system({ 'osascript', '-e', 'tell application "System Events" to key code 102' })
    end
  })
end
