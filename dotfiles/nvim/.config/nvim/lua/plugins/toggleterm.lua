-- terminal --

return {
  'akinsho/toggleterm.nvim',
  version = "*",
  keys = {
    { '<C-t>', '<cmd>lua _float_terminal_toggle()<CR>', mode = 'n' },
    { '<C-t>', '<cmd>lua _float_terminal_toggle()<CR>', mode = 't' },
    { 'tg',    '<cmd>lua _lazygit_toggle()<CR>',        mode = 'n' },
    { 'tg',    '<cmd>lua _lazygit_toggle()<CR>',        mode = 't' }
  },
  config = function()
    -- toggleterm
    local Terminal = require('toggleterm.terminal').Terminal

    -- float terminal
    local float_terminal = Terminal:new({
      direction = 'float',
      hidden = true
    })

    function _float_terminal_toggle()
      float_terminal:toggle()
    end

    -- lazygit
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      direction = 'float',
      hidden = true
    })

    function _lazygit_toggle()
      lazygit:toggle()
    end
  end
}
