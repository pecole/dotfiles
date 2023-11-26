-- telescope --

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-frecency.nvim'
  },
  keys = {
    { '<C-p>', ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git<CR>', mode = 'n' },
    { '<C-g>', ':Telescope live_grep<CR>',                                                 mode = 'n' },
    { '<C-f>', ':Telescope frecency<CR>',                                                  mode = 'n' },
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
          bg = c.bg_dark,
          fg = c.fg_dark,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopePromptNormal = {
          bg = prompt,
        }
        hl.TelescopePromptBorder = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePromptTitle = {
          bg = prompt,
          fg = prompt,
        }
        hl.TelescopePreviewTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
        hl.TelescopeResultsTitle = {
          bg = c.bg_dark,
          fg = c.bg_dark,
        }
      end,
    })
    telescope.load_extension('frecency')
  end
}
