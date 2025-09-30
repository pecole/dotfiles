return {
  -- カラースキーム --
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = false,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme('catppuccin-mocha')
      vim.cmd("highlight TelescopeSelection cterm=bold gui=bold guifg=#a6e3a1 guibg=#181825")
    end
  },
  -- ステータスバー --
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require('lualine').setup({
        theme = 'tokyonight',
      })
    end
  },
  -- インデント可視化 --
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufRead', 'BufNewFile' },
    opts = {},
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "OddIndent", { bg = "#11162c", nocombine = true })
        vim.api.nvim_set_hl(0, "EvenIndent", { bg = "#181f3e", nocombine = true })
      end)
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup { scope = { highlight = highlight } }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      require('ibl').setup()
    end
  },
  -- TODOコメント強調 --
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      'nvim-telescope/telescope.nvim',
    },
    event = 'VeryLazy',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -- カラーピッカー --
  {
    'uga-rosa/ccc.nvim',
    cmd = { 'CccPick' },
    ft = { 'lua', 'css', 'scss', 'html' },
    config = function()
      vim.opt.termguicolors = true
      require('ccc').setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end
  },
  -- バッファライン --
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',   -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    lazy = false,
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    },
    config = function()
      require('barbar').setup(

      )
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }

      -- Move to previous/next
      map('n', '<leader>j', '<Cmd>BufferPrevious<CR>', opts)          --<leader>+jで前のBufferに移動
      map('n', '<leader>k', '<Cmd>BufferNext<CR>', opts)              --<leader>+kで次のBufferに移動
      -- Close buffer
      map('n', '<leader>d', '<Cmd>BufferClose<CR>', opts)             --<leader>+eでBufferを削除
      map('n', '<leader>q', '<Cmd>BufferCloseBuffersRight<CR>', opts) --<leader>+qで右のBufferを削除
      map('n', '<leader>qq', '<Cmd>BufferCloseAllButCurrent<CR>', opts) --<leader>+qqで現在のBuffer以外を削除
    end
  },
}
