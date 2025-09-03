-- Github Copilot Chat --

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    build = "make tiktoken",        -- Only on MacOS or Linux
    opts = {
      debug = true,                 -- Enable debugging
      -- See Configuration section for rest
    },
    event = { 'VeryLazy', 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        "<leader>cc",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "Toggle Copilot Chat UI"
      },
    },
  },
}
