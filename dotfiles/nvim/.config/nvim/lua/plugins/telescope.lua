-- telescope --

local function live_grep()
  local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
  if vim.v.shell_error == 0 then
    require('telescope.builtin').live_grep({ cwd = root })
  else
    require('telescope.builtin').live_grep()
  end
end

return {
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
    vim.keymap.set('n', '<leader>fp', require("telescope").extensions.frecency.frecency, { desc = 'Telescope - Frecency' })

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
