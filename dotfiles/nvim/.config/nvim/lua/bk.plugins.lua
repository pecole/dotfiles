return {
  -- カラースキーム
  {
    'kihachi2000/yash.nvim',
    config = function()
      vim.opt.termguicolors = true
      vim.cmd('colorscheme yash')
    end
  },
  -- ファイラー
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup()
    end
  },
  -- インデント可視化
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    config = function()
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "OddIndent", { bg = "#11162c", nocombine = true })
        vim.api.nvim_set_hl(0, "EvenIndent", { bg = "#181f3e", nocombine = true })
      end)

      local highlight_list = {
        "OddIndent",
        "EvenIndent",
      }

      require("ibl").setup({
        indent = { highlight = highlight_list, char = "" },
        whitespace = { highlight = highlight_list, remove_blankline_trail = false },
        scope = { enabled = false },
      })
    end
  },
  -- telescope
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-frecency.nvim'
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup()
      telescope.load_extension('frecency')
    end
  },
  -- ステータスバー
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require('lualine').setup()
    end
  },
  -- スニペット
  { 'hrsh7th/vim-vsnip',            event = 'InsertEnter' },
  { 'hrsh7th/cmp-vsnip',            event = 'InsertEnter' },
  { 'rafamadriz/friendly-snippets', event = 'InsertEnter' },
  -- LSP
  { 'neovim/nvim-lspconfig' },
  {
    'williamboman/mason.nvim',
    event = { 'BufReadPre', 'VimEnter' },
    config = function()
      require('mason').setup({
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '→',
            package_uninstalled = '✗'
          }
        }
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = 'BufReadPre',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup()
      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = { globals = { 'vim' } }
              }
            }
          }
        end
      }
    end
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'VimEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-emoji' },
      { 'hrsh7th/cmp-vsnip' },
      { 'onsails/lspkind.nvim' },
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 100 },
          { name = 'vsnip',    priority = 70 },
          { name = 'emoji',    priority = 50, insert = true },
        }, {
          { name = 'buffer' },
        }),
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        formatting = {
          format = require('lspkind').cmp_format({
            with_text = true,
            menu = {
              buffer = '[A]',
              nvim_lsp = '[LSP]',
              vsnip = '[snip]',
              emoji = '[emoji]',
            },
          })
        },
      })
    end
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup()
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = function()
      require('neogit').setup()
    end
  },
  -- terminal
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = true
  },
  -- github copilot
  {
    'github/copilot.vim',
  }
}
