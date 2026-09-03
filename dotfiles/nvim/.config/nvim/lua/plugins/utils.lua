return {
  -- コードハイライト --
  {
    'romus204/tree-sitter-manager.nvim',
    -- ハイライト/自動インストールは FileType で走るので BufReadPre で間に合う
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'TSManager', 'TSInstall', 'TSUpdate', 'TSUninstall' },
    config = function()
      require('tree-sitter-manager').setup({
        ensure_installed = { "lua", "bash", "awk", "json", "diff" },
        auto_install = true,
      })
    end,
  },
  -- 自動括弧閉じ --
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  -- HTML, XMLのタグ自動閉じ --
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  -- コメントアウト --
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('Comment').setup()
    end
  },
  -- vim help 日本語訳 --
  {
    'vim-jp/vimdoc-ja',
    keys = {
      { 'h', mode = 'c' },
    },
    init = function()
      -- vimdoc-ja は doc/tags-ja をリポジトリに含んでいるが、lazy.nvim が更新後に
      -- :helptags で再生成するため作業ツリーが汚れ、次回更新の git checkout が失敗する。
      -- 更新処理の直前に復元しておく。skip-worktree が立っていると checkout -- が
      -- 効かないので先に落とす。
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'LazyUpdatePre', 'LazySyncPre', 'LazyRestorePre' },
        callback = function()
          local dir = vim.fn.stdpath('data') .. '/lazy/vimdoc-ja'
          if not vim.uv.fs_stat(dir .. '/.git') then
            return
          end
          vim.system({ 'git', '-C', dir, 'update-index', '--no-skip-worktree', 'doc/tags-ja' }):wait()
          vim.system({ 'git', '-C', dir, 'checkout', '--', 'doc/tags-ja' }):wait()
        end,
      })
    end,
  },
}
