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

command("CpCurrentLine", function()
  local path = vim.fn.expand("%:p:.")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local copied = "at " .. line .. " in " .. path
  vim.fn.setreg("+", copied)
  vim.notify('Copied "' .. copied .. '" to the clipboard!')
end, {})

command("CpSelectedLines", function()
  local path = vim.fn.expand("%:p:.")
  local s, e = vim.fn.line("."), vim.fn.line("v")
  --vim.fn.line("."): the current line in visual mode
  --vim.fn.line("v"): the another end of the line in visual mode
  --swap if s is greater than e
  if s > e then s, e = e, s end
  local lines = s .. "-" .. e
  local copied = "at " .. lines .. " in " .. path
  vim.fn.setreg("+", copied)
  vim.notify('Copied "' .. copied .. '" to the clipboard!')
end, { range = true })

command("CpError", function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
  if #diags == 0 then return vim.notify("No diagnostics") end
  local path = vim.fn.expand("%:p:.")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local copied = "Do you know why the following error occurs at " ..
  line .. " in " .. path .. "?\n\n" .. diags[1].message
  vim.fn.setreg("+", copied)
  vim.notify('Copied error messages to the clipboard!')
end, { range = true })
