--local command = vim.create_user_command
local command = vim.api.nvim_create_user_command

-- Command --
-- :T で下部ペインにterminalを開く
--command('T', 'split | wincmd j | resize 20 | terminal', {})

