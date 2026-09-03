-- =============================================================================
-- ファイルを探す・移動する
--
--   nvim-tree … 左右にフォルダのツリーを出すファイラー
--   telescope … ファイル名や中身をあいまい検索する
--   flash     … 画面内の好きな位置へ数キーで飛ぶ
--   aerial    … ファイル内の関数一覧を出して飛ぶ
-- =============================================================================


-- telescope の「ファイルの中身を検索」用の関数
--
-- git リポジトリの中にいるときは、今いるフォルダではなく
-- リポジトリ全体を検索対象にしたいので、その根っこを探して渡す
local function live_grep()
  -- vim.fs.root は「.git があるフォルダ」を上に辿って探してくれる。
  -- 見つからなければ nil が返る
  local root = vim.fs.root(0, '.git')
  require('telescope.builtin').live_grep(root and { cwd = root } or {})
end


return {
  -- ---------------------------------------------------------------------------
  -- nvim-tree — ファイラー (<leader>e で開閉)
  -- ---------------------------------------------------------------------------
  {
    'nvim-tree/nvim-tree.lua',

    dependencies = {
      'nvim-tree/nvim-web-devicons',   -- ファイル種別ごとのアイコン
    },

    keys = {
      { '<leader>e', function() require('nvim-tree.api').tree.toggle() end,
        desc = 'NvimTree - 開閉' },
    },

    config = function()
      require('nvim-tree').setup({
        -- 並び順を拡張子ごとにする
        sort = {
          sorter = 'extension',
        },

        -- 今開いているファイルの位置にツリーを合わせる
        update_focused_file = {
          enable = true,
          update_root = { enable = true },   -- 必要ならツリーの根っこも移動する
        },

        view = {
          width = '25%',
          side = 'right',       -- 画面の右側に出す
          signcolumn = 'no',    -- ツリー内に記号欄は不要
        },

        renderer = {
          highlight_git = 'name',           -- gitの状態でファイル名に色を付ける
          highlight_opened_files = 'name',  -- 開いているファイルの名前を強調する

          icons = {
            glyphs = {
              -- gitの状態を表す記号
              git = {
                unstaged  = '!',   -- 変更したがまだ登録していない
                staged    = '✓',   -- 登録済み
                unmerged  = '',   -- マージの途中
                renamed   = '»',   -- 名前が変わった
                untracked = '?',   -- git管理外の新しいファイル
                deleted   = '✘',   -- 削除された
                ignored   = '◌',   -- .gitignore で無視されている
              },
            },
          },
        },

        git = {
          enable = true,
          ignore = false,   -- .gitignore されたファイルも表示する
        },

        actions = {
          -- 全部展開するときに開きすぎないようにする
          expand_all = {
            max_folder_discovery = 100,
            exclude = { '.git', 'target', 'build' },
          },
        },

        on_attach = 'default',   -- ツリー内のキー操作は既定のものを使う
      })
    end
  },

  -- ---------------------------------------------------------------------------
  -- telescope — あいまい検索
  -- ---------------------------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',

    dependencies = {
      { 'nvim-lua/plenary.nvim' },                  -- 多くのプラグインが使う共通部品
      { 'nvim-telescope/telescope-frecency.nvim' }, -- よく開くファイルを上位に出す
    },

    cmd = 'Telescope',

    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end,
        desc = 'Telescope - ファイル名で探す' },
      { '<leader>fg', live_grep,
        desc = 'Telescope - ファイルの中身を探す' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end,
        desc = 'Telescope - 開いているファイルから探す' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end,
        desc = 'Telescope - ヘルプを探す' },
      { '<leader>fp', function() require('telescope').extensions.frecency.frecency() end,
        desc = 'Telescope - よく開くファイルから探す' },
    },

    config = function()
      local telescope = require('telescope')
      local telescopeConfig = require('telescope.config')

      -- 検索コマンド(ripgrep)に渡す引数を、既定のものを写してから足す。
      -- 元の設定を直接書き換えないようコピーしている
      local vimgrep_arguments = vim.deepcopy(telescopeConfig.values.vimgrep_arguments)
      vim.list_extend(vimgrep_arguments, {
        '--hidden',                  -- ドットで始まる隠しファイルも探す
        '--glob', '!**/.git/*',      -- ただし .git の中身は除く
      })

      telescope.setup({
        defaults = {
          vimgrep_arguments = vimgrep_arguments,
        },
        pickers = {
          find_files = {
            -- ファイル名検索も同じ方針にそろえる
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
        },
      })

      telescope.load_extension('frecency')
    end
  },

  -- ---------------------------------------------------------------------------
  -- flash — 画面内の好きな位置へ飛ぶ
  --
  -- s を押して飛びたい場所の文字を打つと、目印の文字が出る。
  -- その文字を押すとそこへ移動する
  -- ---------------------------------------------------------------------------
  {
    'folke/flash.nvim',

    ---@type Flash.Config
    opts = {},

    -- stylua: ignore
    keys = {
      { 's',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash - 移動' },
      { 'S',     mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,        desc = 'Flash - 構文の単位で選ぶ' },
      { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Flash - 離れた場所を操作対象にする' },
      { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Flash - 構文を検索して選ぶ' },
      { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Flash - 検索中の候補表示を切替' },
    },
  },

  -- ---------------------------------------------------------------------------
  -- aerial — ファイル内の関数や見出しの一覧
  -- ---------------------------------------------------------------------------
  {
    'stevearc/aerial.nvim',

    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },

    event = { 'BufReadPre', 'BufNewFile' },

    keys = {
      { '<leader>a', '<cmd>AerialToggle!<CR>', desc = 'Aerial - 一覧の開閉' },
    },

    opts = {
      -- aerial が使えるファイルでだけ有効になるキー
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>',
          { buffer = bufnr, desc = 'Aerial - 前の関数へ' })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>',
          { buffer = bufnr, desc = 'Aerial - 次の関数へ' })
      end,
    },
  },
}
