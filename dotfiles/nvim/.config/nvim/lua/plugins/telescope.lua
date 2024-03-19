-- telescope --

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-frecency.nvim' },
  },
  keys = {
    { '<leader>ff',       '<cmd>Telescope find_files<cr>', mode = 'n' },
    { '<leader>fg',       '<cmd>Telescope live_grep<cr>',  mode = 'n' },
    --{ '<leader>fb', '<cmd>Telescope buffers<cr>', mode = 'n' },
    { '<leader>fh',       '<cmd>Telescope help_tags<cr>',  mode = 'n' },
    { '<leader><leader>', '<cmd>Telescope frecency<cr>',   mode = 'n' },
  },
  config = function()
    --local builtin = require('telescope.builtin')
    --vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    --vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    --vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    --vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

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
}
