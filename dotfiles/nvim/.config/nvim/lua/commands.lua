--local command = vim.create_user_command
local command = vim.api.nvim_create_user_command

-- Command --
-- :T で下部ペインにterminalを開く
--command('T', 'split | wincmd j | resize 20 | terminal', {})

-- :Soで設定ファイル際読み込み
command(
  'So',
  function(opts)
    if #opts.fargs > 0 then
      vim.cmd('source ' .. opts.fargs[1])
    else
      vim.cmd('source $MYVIMRC')
    end
  end,
  { nargs = '*' }
)
