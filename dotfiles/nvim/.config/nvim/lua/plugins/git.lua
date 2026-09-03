-- =============================================================================
-- Git 連携
--
--   gitsigns  … 変更した行を画面の左端に印で表示し、行単位の操作もできる
--   diffview  … 変更内容を左右に並べて比較する画面を出す
--
-- キーはどちらも <leader>h から始まる (h = hunk = 変更のかたまり)
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- gitsigns — 変更行の表示と、行単位の add / 取り消し
  -- ---------------------------------------------------------------------------
  {
    'lewis6991/gitsigns.nvim',

    event = { 'BufRead', 'BufNewFile' },

    config = function()
      require('gitsigns').setup({
        -- on_attach は「gitリポジトリ内のファイルを開いたとき」に呼ばれる。
        -- ここでキーを割り当てると、git管理下のファイルでだけ有効になる
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- このファイルの中だけで有効なキーを割り当てる小さな道具
          local function map(mode, key, action, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, key, action, opts)
          end

          -- 変更箇所を行き来する ------------------------------------------
          -- 差分表示中(vim.wo.diff)は Neovim 本来の ]c / [c をそのまま使う。
          -- expr = true は「返した文字列をキー入力として扱う」という指定
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          -- 変更を git に登録する / 取り消す --------------------------------
          map('n', '<leader>hs', gs.stage_hunk)      -- この変更を登録
          map('n', '<leader>hr', gs.reset_hunk)      -- この変更を取り消し
          map('n', '<leader>hS', gs.stage_buffer)    -- ファイル全体を登録
          map('n', '<leader>hR', gs.reset_buffer)    -- ファイル全体を取り消し
          map('n', '<leader>hu', gs.undo_stage_hunk) -- 登録を取り消す

          -- 選択した範囲だけを対象にする版
          map('v', '<leader>hs', function()
            gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
          end)
          map('v', '<leader>hr', function()
            gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
          end)

          -- 中身を見る ------------------------------------------------------
          map('n', '<leader>hp', gs.preview_hunk)            -- 変更内容を表示
          map('n', '<leader>hd', gs.diffthis)                -- 今の状態と比較
          map('n', '<leader>hD', function() gs.diffthis('~') end)  -- 1つ前と比較
          map('n', '<leader>hb', function() gs.blame_line { full = true } end)  -- 誰がいつ書いたか

          -- 表示の切り替え --------------------------------------------------
          map('n', '<leader>tb', gs.toggle_current_line_blame) -- 行末に作者を出す
          map('n', '<leader>td', gs.toggle_deleted)            -- 削除された行を出す

          -- 変更のかたまりを選択範囲として扱う (dih で1かたまり削除、など)
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  },

  -- ---------------------------------------------------------------------------
  -- diffview — 変更内容を左右に並べて見る
  --
  -- <leader>hd は上の gitsigns がファイル内で先に押さえているので、
  -- ここでは <leader>hm を使う (m = merge)
  -- ---------------------------------------------------------------------------
  {
    'sindrets/diffview.nvim',

    dependencies = { 'nvim-lua/plenary.nvim' },

    -- 下のコマンドかキーを使ったときに読み込む
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },

    keys = {
      { '<leader>hh', '<cmd>DiffviewOpen HEAD~1<CR>',   desc = 'Diffview - 1つ前とのdiff' },
      { '<leader>hf', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diffview - このファイルの変更履歴' },
      { '<leader>hc', '<cmd>DiffviewClose<CR>',         desc = 'Diffview - 画面を閉じる' },
      { '<leader>hm', '<cmd>DiffviewOpen<CR>',          desc = 'Diffview - コンフリクト解消画面' },
    },

    config = function()
      require('diffview').setup()
    end,
  },
}
