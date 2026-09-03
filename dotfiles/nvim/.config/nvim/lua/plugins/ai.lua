-- =============================================================================
-- GitHub Copilot — 書いている途中のコードの続きを提案してくれる
--
-- 提案は薄い文字で先に表示され、Ctrl-l を押すと採用される。
-- =============================================================================

return {
  {
    'zbirenbaum/copilot.lua',

    cmd = 'Copilot',           -- :Copilot を実行したとき
    event = 'InsertEnter',     -- または文字を打ち始めたときに読み込む

    config = function()
      require('copilot').setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,   -- 何もしなくても勝手に提案を出す

          keymap = {
            accept = '<C-l>',      -- 提案をまるごと採用する
            accept_word = false,   -- 単語だけ採用する機能は使わない
            accept_line = false,   -- 1行だけ採用する機能は使わない
            next = '<M-]>',        -- 次の提案を見る (M- は Alt キー)
            prev = '<M-[>',        -- 前の提案を見る
            dismiss = '<C-]>',     -- 提案を消す
          },
        },

        -- 提案を一覧表示するパネルは使わない
        panel = { enabled = false },

        -- Copilot は Node.js で動く
        copilot_node_command = 'node',
      })
    end,
  },
}
