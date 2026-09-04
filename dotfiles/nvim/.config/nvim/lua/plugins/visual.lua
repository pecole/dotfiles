-- =============================================================================
-- 見た目に関するプラグイン
--
--   catppuccin     … 配色 (カラースキーム)
--   lualine        … 画面下のステータスライン
--   indent-blankline … インデントを縦線で見やすくする
--   todo-comments  … TODO や FIXME を目立たせる
--   nvim-colorizer … "#E06C75" のような色コードを実際の色で表示する
--   barbar         … 画面上部に開いているファイルをタブのように並べる
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- catppuccin — 配色
  --
  -- 配色は画面を描く前に決まっている必要があるので、待たずに読み込む
  --   lazy = false     … 起動時に読み込む
  --   priority = 1000  … 他のプラグインより先に読み込む
  -- ---------------------------------------------------------------------------
  {
    'catppuccin/nvim',
    name = 'catppuccin',

    lazy = false,
    priority = 1000,

    config = function()
      require('catppuccin').setup({
        -- ターミナル側の背景を透かして見せる
        transparent_background = true,

        -- catppuccin は既定で「どのプラグインが入っているか」を毎回調べて
        -- 対応する配色を有効にする。この検出に約5.6msかかるので、
        -- 検出をやめて結果を直接書いておく。
        -- (プラグインを増やしたときはここに1行足す)
        auto_integrations = false,
        integrations = {
          aerial = { enabled = true },
          barbar = { enabled = true },
          blink_cmp = { enabled = true },
          diffview = { enabled = true },
          flash = { enabled = true },
          gitsigns = { enabled = true },
          indent_blankline = { enabled = true },
          mason = { enabled = true },
          nvimtree = { enabled = true },
          telescope = { enabled = true },
        },
      })

      vim.cmd.colorscheme('catppuccin-mocha')   -- mocha = 一番暗い配色

      -- telescope で選択中の行が見づらいので、色を上書きする
      vim.cmd('highlight TelescopeSelection cterm=bold gui=bold guifg=#a6e3a1 guibg=#181825')
    end
  },

  -- ---------------------------------------------------------------------------
  -- lualine — 画面下のステータスライン (モードやファイル名を表示)
  -- ---------------------------------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',

    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },

    event = { 'BufNewFile', 'BufRead' },

    opts = {
      options = {
        -- 'auto' は今の配色(catppuccin)に合わせて色を選ぶという指定。
        -- ※ theme はトップレベルではなく options の中に書く必要がある
        theme = 'auto',
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- indent-blankline — インデントの深さを縦線で表示する
  --
  -- 縦線の色を7色用意し、今カーソルがあるブロックの線だけ色を変える
  -- ---------------------------------------------------------------------------
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',   -- require する名前がリポジトリ名と違うので指定する

    event = { 'BufRead', 'BufNewFile' },

    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      -- 色の定義は HIGHLIGHT_SETUP という「合図」に登録しておく。
      -- こうすると配色を変えたときに自動で作り直される
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed',    { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue',   { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen',  { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan',   { fg = '#56B6C2' })
      end)

      -- カーソルのあるブロックの色を決める方法を登録する
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      -- setup は1回だけ呼ぶこと。
      -- 2回呼ぶと、あとの呼び出しで前の設定が消えてしまう
      require('ibl').setup({ scope = { highlight = highlight } })
    end
  },

  -- ---------------------------------------------------------------------------
  -- todo-comments — TODO: や FIXME: を色付きで目立たせる
  -- ---------------------------------------------------------------------------
  {
    'folke/todo-comments.nvim',

    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',   -- :TodoTelescope で一覧を出すため
    },

    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- ---------------------------------------------------------------------------
  -- nvim-colorizer — 色コードをその色で表示する
  --
  -- "#E06C75" と書いてある部分が実際に赤く見えるようになる。
  -- 以前は ccc.nvim を使っていたが更新が止まっていたため、
  -- 活発に更新されているこちらに移行した
  -- ---------------------------------------------------------------------------
  {
    'catgoose/nvim-colorizer.lua',

    ft = { 'lua', 'css', 'scss', 'html' },

    opts = {
      filetypes = { 'lua', 'css', 'scss', 'html' },
      user_default_options = {
        css = true,      -- CSS の色指定 (rgb() など) にも対応する
        css_fn = true,   -- CSS の関数形式にも対応する
        lsp = true,      -- 言語サーバーが教えてくれる色情報も使う
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- barbar — 画面上部に開いているファイルをタブのように並べる
  --
  -- git の変更状態も表示できるが、そのために gitsigns を dependencies に
  -- 入れてはいけない。dependencies にすると gitsigns が
  -- 「必要になるまで待つ」設定を無視して起動時に読み込まれてしまう。
  -- barbar は変数(b:gitsigns_status_dict)を覗くだけの緩いつながりなので、
  -- gitsigns が読み込まれていれば自然に連携する
  -- ---------------------------------------------------------------------------
  {
    'romgrk/barbar.nvim',

    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },

    event = { 'BufReadPre', 'BufNewFile' },

    -- barbar が自分で setup を呼ぶのを止める (opts の内容で呼んでもらうため)
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},

    keys = {
      { '<leader>j', '<Cmd>BufferPrevious<CR>',           desc = 'Barbar - 前のファイルへ' },
      { '<leader>k', '<Cmd>BufferNext<CR>',               desc = 'Barbar - 次のファイルへ' },
      { '<leader>d', '<Cmd>BufferClose<CR>',              desc = 'Barbar - このファイルを閉じる' },
      { '<leader>q', '<Cmd>BufferCloseBuffersRight<CR>',  desc = 'Barbar - 右側をまとめて閉じる' },
      { '<leader>Q', '<Cmd>BufferCloseAllButCurrent<CR>', desc = 'Barbar - このファイル以外を閉じる' },
    },
  },
}
