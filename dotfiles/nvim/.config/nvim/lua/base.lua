-- vim.cmd('autocmd!')

vim.scriptencoding = 'utf-8'

vim.wo.number = true

vim.g.python_host_prog = vim.fn.system('which python')
vim.g.python3_host_prog = vim.fn.system('which python3')

-- set ermguicolors to enable highlight groups
vim.opt.termguicolors = true

-- disabled netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set ermguicolors to enable highlight groups
vim.opt.termguicolors = true
-- isnertモードらnormalモードに切り替え時imeをオフにする
if vim.fn.has('mac') == 1 then
  vim.opt.ttimeoutlen = 1
  vim.g.imeoff = 'osascript -e \"tell application \\\"System Events\\\" to key code 102\"'
  vim.api.nvim_create_augroup('MyIMEGroup', {})
  vim.api.nvim_create_autocmd('InsertLeave', {
    group = 'MyIMEGroup',
    pattern = '*',
    callback = function()
      os.execute(vim.g.imeoff)
    end
  })
end
