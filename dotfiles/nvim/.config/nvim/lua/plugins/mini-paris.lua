-- 括弧 --
return {
  'echasnovski/mini.pairs',
  version = false,
  event = { 'InsertEnter' },
  config = function()
    require('mini.pairs').setup()
  end
}
