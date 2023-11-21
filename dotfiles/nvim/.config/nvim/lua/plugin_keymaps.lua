--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
-- nvim-tree --
keymap('n', '<C-e>', ':NvimTreeToggle<CR>', opts)

-- Telescope --
keymap('n', '<C-p>', ':Telescope find_files<CR>', opts)
keymap('n', '<C-g>', ':Telescope live_grep<CR>', opts)
keymap('n', '<C-f>', ':Telescope frecency<CR>', opts)
keymap('n', '<C-b>', ':Telescope file_browser<CR>', opts)

-- lspconfig --
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', 'e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', 'q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local vim_opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim_opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim_opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim_opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim_opts)
    --    vim.keymap.set('n', '', vim.lsp.buf.signature_help, vim_opts)
    vim.keymap.set('n', 'wa', vim.lsp.buf.add_workspace_folder, vim_opts)
    vim.keymap.set('n', 'wr', vim.lsp.buf.remove_workspace_folder, vim_opts)
    vim.keymap.set('n', 'wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim_opts)
    vim.keymap.set('n', 'D', vim.lsp.buf.type_definition, vim_opts)
    vim.keymap.set('n', 'rn', vim.lsp.buf.rename, vim_opts)
    vim.keymap.set({ 'n', 'v' }, 'ca', vim.lsp.buf.code_action, vim_opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim_opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- toggleterm --
local Terminal = require('toggleterm.terminal').Terminal

-- float terminal
local float_terminal = Terminal:new({
  direction = 'float',
  hidden = true
})

function _float_terminal_toggle()
  float_terminal:toggle()
end

keymap('n', '<C-t>', '<cmd>lua _float_terminal_toggle()<CR>', opts)
keymap('t', '<C-t>', '<cmd>lua _float_terminal_toggle()<CR>', opts)

-- lazygit
local lazygit = Terminal:new({
  cmd = 'lazygit',
  direction = 'float',
  hidden = true
})

function _lazygit_toggle()
  lazygit:toggle()
end

keymap('n', 'tg', '<cmd>lua _lazygit_toggle()<CR>', opts)
