-- terminal --

return {
  'akinsho/toggleterm.nvim',
  version = "*",
  keys = {
    { '<leader>t',  '<cmd>lua _float_terminal_toggle()<CR>', mode = 'n' },
    { '<leader>t',  '<cmd>lua _float_terminal_toggle()<CR>', mode = 't' },
    { '<leader>tg', '<cmd>lua _lazygit_toggle()<CR>',        mode = 'n' },
    { '<leader>tg', '<cmd>lua _lazygit_toggle()<CR>',        mode = 't' }
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
