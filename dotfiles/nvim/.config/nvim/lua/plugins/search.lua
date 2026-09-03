-- git管理下ならリポジトリルートを対象に live_grep する
local function live_grep()
  local root = vim.fs.root(0, '.git')
  require('telescope.builtin').live_grep(root and { cwd = root } or {})
end

return {
  -- ファイラー --
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>e', function() require('nvim-tree.api').tree.toggle() end, desc = 'NvimTree - toggle' },
    },
    config = function()
      require('nvim-tree').setup({
        -- sort_by / update_cwd / highlight_git=true は旧式の書き方で、
        -- 現在は legacy 互換層で読み替えられているだけなので現行の形に直す
        sort = {
          sorter = 'extension',
        },
        update_focused_file = {
          enable = true,
          update_root = {
            enable = true,
          },
        },
        view = {
          width = '25%',
          side = 'right',
          signcolumn = 'no',
        },

        renderer = {
          highlight_git = 'name',
          highlight_opened_files = 'name',
          icons = {
            glyphs = {
              git = {
                unstaged = '!',
                renamed = '»',
                untracked = '?',
                deleted = '✘',
                staged = '✓',
                unmerged = '',
                ignored = '◌',
              },
            },
          },
        },

        git = {
          enable = true,
          ignore = false,
        },

        actions = {
          expand_all = {
            max_folder_discovery = 100,
            exclude = { '.git', 'target', 'build' },
          },
        },

        on_attach = 'default'
      })
    end
  },
  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-frecency.nvim' },
    },
    cmd = 'Telescope',
    keys = {
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Telescope - Find files' },
      { '<leader>fg', live_grep,                                               desc = 'Telescope - Live grep' },
      { '<leader>fb', function() require('telescope.builtin').buffers() end,   desc = 'Telescope - Buffers' },
      { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Telescope - Help tags' },
      {
        '<leader>fp',
        function() require('telescope').extensions.frecency.frecency() end,
        desc = 'Telescope - Frecency'
      },
    },
    config = function()
      local telescope = require('telescope')
      local telescopeConfig = require("telescope.config")

      -- 既定の vimgrep_arguments を複製して隠しファイルも検索対象にする
      -- (.git ディレクトリの中までは検索しない)
      local vimgrep_arguments = vim.deepcopy(telescopeConfig.values.vimgrep_arguments)
      vim.list_extend(vimgrep_arguments, { "--hidden", "--glob", "!**/.git/*" })

      telescope.setup({
        defaults = {
          -- `hidden = true` is not supported in text grep commands.
          vimgrep_arguments = vimgrep_arguments,
        },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      })
      telescope.load_extension('frecency')
    end
  },
  -- flash
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  -- 関数を一覧表示してジャンプできる
  {
    'stevearc/aerial.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>a', '<cmd>AerialToggle!<CR>', desc = 'Aerial - toggle' },
    },
    opts = {
      -- aerial がバッファにアタッチしたときだけ有効なキーマップ
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Aerial - prev' })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Aerial - next' })
      end,
    },
  },
}
