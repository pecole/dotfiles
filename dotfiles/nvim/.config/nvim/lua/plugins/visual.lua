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
    opts = {
      -- テーマは theme ではなく options.theme に置く必要がある。
      -- 'auto' は colorscheme (catppuccin-mocha) に追従する
      options = {
        theme = 'auto',
      },
    },
  },
  -- インデント可視化 --
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufRead', 'BufNewFile' },
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
      -- ハイライト定義は HIGHLIGHT_SETUP フックに登録しておくと
      -- colorscheme が変わるたびに再作成される
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      require("ibl").setup({ scope = { highlight = highlight } })
    end
  },
  -- TODOコメント強調 --
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      'nvim-telescope/telescope.nvim',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
  -- カラーコードのハイライト --
  -- 更新が止まっていた ccc.nvim から、活発にメンテされている
  -- catgoose/nvim-colorizer.lua に置き換えた
  {
    'catgoose/nvim-colorizer.lua',
    ft = { 'lua', 'css', 'scss', 'html' },
    opts = {
      filetypes = { 'lua', 'css', 'scss', 'html' },
      user_default_options = {
        css = true,
        css_fn = true,
        lsp = true,
      },
    },
  },
  -- バッファライン --
  -- gitsigns は b:gitsigns_status_dict 経由の疎結合なので dependencies にしない
  -- (dependencies にすると gitsigns 自身の遅延ロード指定が無効化されてしまう)
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
    keys = {
      { '<leader>j', '<Cmd>BufferPrevious<CR>',          desc = 'Barbar - 前のバッファ' },
      { '<leader>k', '<Cmd>BufferNext<CR>',              desc = 'Barbar - 次のバッファ' },
      { '<leader>d', '<Cmd>BufferClose<CR>',             desc = 'Barbar - バッファを閉じる' },
      { '<leader>q', '<Cmd>BufferCloseBuffersRight<CR>', desc = 'Barbar - 右のバッファを閉じる' },
      { '<leader>Q', '<Cmd>BufferCloseAllButCurrent<CR>', desc = 'Barbar - 現在以外を閉じる' },
    },
  },
}
