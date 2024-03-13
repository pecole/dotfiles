vim.cmd('autocmd!')

vim.scriptencoding = 'utf-8'

vim.wo.number = true

vim.g.python_host_prog = vim.fn.system('which python')
vim.g.python3_host_prog = vim.fn.system('which python3')
