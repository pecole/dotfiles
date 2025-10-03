return {
  {
    "zbirenbaum/copilot-cmp",
    lazy = false,
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    event = { 'VeryLazy', 'BufReadPre', 'BufNewFile' },
    config = function()
      -- lspのハンドラーに設定
      -- capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- lspの設定後に追加
      vim.opt.completeopt = "menu,menuone,noselect"

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end

      local cmp = require "cmp"
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          --["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp',               keyword_length = 1 },
          { name = 'copilot' },
          { name = 'vsnip',                  keyword_length = 2 },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua',               keyword_length = 2 },
          { name = 'calc' },
          { name = 'buffer',                 keyword_length = 2 },
          { name = 'path' },
        }),
      })
    end
  }
}
