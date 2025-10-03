local function live_grep()
  local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
  if vim.v.shell_error == 0 then
    require('telescope.builtin').live_grep({ cwd = root })
  else
    require('telescope.builtin').live_grep()
  end
end

return {
  -- ファイラー --
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>e', mode = 'n' },
    },
    config = function()
      require('nvim-tree').setup({
        sort_by = 'extension',
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        view = {
          width = '25%',
          side = 'right',
          signcolumn = 'no',
        },

        renderer = {
          highlight_git = true,
          highlight_opened_files = 'name',
          icons = {
            glyphs = {
              git = {
                unstaged = '!',
                renamed = '»',
                untracked = '?',
                deleted = '✘',
                staged = '✓',
                unmerged = '',
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

      local api = require('nvim-tree.api')
      vim.keymap.set('n', '<leader>e', api.tree.toggle, { desc = 'NvimTree - toggle' })
    end
  },
  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-frecency.nvim' },
    },
    event = "VeryLazy",
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope - Find files' })
      vim.keymap.set('n', '<leader>fg', live_grep, { desc = 'Telescope - Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope - Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope - Help tags' })
      vim.keymap.set('n', '<leader>fp', require("telescope").extensions.frecency.frecency,
        { desc = 'Telescope - Frecency' })

      local telescope = require('telescope')
      local telescopeConfig = require("telescope.config")

      -- Clone the default Telescope configuration
      local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

      -- I want to search in hidden/dot files.
      table.insert(vimgrep_arguments, "--hidden")
      -- I don't want to search in the `.git` directory.
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")
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
    event = "VeryLazy",
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
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require("aerial").setup({
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          local map = vim.keymap.set
          local opts = { buffer = bufnr }
          -- Jump forwards/backwards with '{' and '}'
          map("n", "{", "<cmd>AerialPrev<CR>", opts)
          map("n", "}", "<cmd>AerialNext<CR>", opts)
        end,
      })
      -- You probably also want to set a keymap to toggle aerial
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end
  },
}
