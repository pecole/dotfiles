-- terminal --

-- グローバル関数を定義せずに済むよう、生成した Terminal をここに保持する
local terminals = {}

-- 遅延ロード後に呼ばれるので require はコールバックの中で行う
local function toggle(name, opts)
  return function()
    if not terminals[name] then
      terminals[name] = require('toggleterm.terminal').Terminal:new(opts)
    end
    terminals[name]:toggle()
  end
end

local float_terminal = toggle('float', { direction = 'float', hidden = true })
local lazygit = toggle('lazygit', { cmd = 'lazygit', direction = 'float', hidden = true })

return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {},
  keys = {
    { '<leader>tt', float_terminal, mode = { 'n', 't' }, desc = 'ToggleTerm - フロートターミナル' },
    { '<leader>tg', lazygit,        mode = { 'n', 't' }, desc = 'ToggleTerm - lazygit' },
  },
}
