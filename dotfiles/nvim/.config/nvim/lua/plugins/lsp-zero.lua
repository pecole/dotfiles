-- lsp-zero --

return {

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    --event = { 'InsertEnter' },
    dependencies = {
      { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x', },
      { "L3MON4D3/LuaSnip" },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'folke/neodev.nvim' },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'onsails/lspkind-nvim' },
    },
    config = function()
      -- This is where all the LSP shenanigans will live

      local lsp_zero = require('lsp-zero')
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end)
      end)

      require('neodev').setup()
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            require('lspconfig').lua_ls.setup({
              settings = {
                Lua = {
                  completion = {
                    callSnippet = 'Replace',
                  }
                },
              },
            })
          end,
        }
      })

      lsp_zero.set_sign_icons({
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = '»'
      })

      lsp_zero.setup()

      -- nvim-cmp
      local cmp = require('cmp')
      local lspkind = require('lspkind')

      cmp.setup({
        enabled = true,
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<tab>'] = cmp.mapping.confirm({ select = true }),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = lspkind.cmp_format({
            mode = 'text',
          }),
        },
      })
    end
  }
}
