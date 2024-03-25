-- github copilot

vim.g.copilot_no_tab_map = true

return {
  'github/copilot.vim',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
  end
}
