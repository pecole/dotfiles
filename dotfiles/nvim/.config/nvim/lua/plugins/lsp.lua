-- lsp settings --

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float, { desc = "Diagnostic - open float" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Diagnostic - goto preve" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Diagnostic - goto next" })
vim.keymap.set('n', '<space>ll', vim.diagnostic.setloclist, { desc = "Diagnostic - setcloclist" })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Buffer - declaration" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = "Buffer - definition" })
    vim.keymap.set('n', 'gk', vim.lsp.buf.hover, { buffer = ev.buf, desc = "Buffer - hover" })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Buffer - implementation" })
    vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Buffer - signature help" })
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
      { buffer = ev.buf, desc = "Buffer - add workspace folder" })
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
      { buffer = ev.buf, desc = "Buffer - remove workspace folder" })
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { buffer = ev.buf, desc = "Buffer - ls workspace folders" })
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Buffer - type definition" })
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = "Buffer - rename" })
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Buffer - code action" })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = "Buffer - references" })
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, { buffer = ev.buf, desc = "Buffer - format" })
  end,
})

return {
  'williamboman/mason.nvim',
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'jose-elias-alvarez/null-ls.nvim' },
  },
  event = { 'VeryLazy', 'BufReadPre', 'BufNewFile' },
  config = function()
    local mason = require('mason')
    local mason_lspconfig = require('mason-lspconfig')
    local lspconfig = require('lspconfig')

    mason.setup()
    mason_lspconfig.setup()
    mason_lspconfig.setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({})
      end
    })
  end
}
