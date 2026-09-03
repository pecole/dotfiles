local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  defaults = {
    lazy = true,
  },
  -- luarocks を必要とするプラグインが無いため luarocks 連携ごと無効化する
  -- (hererocks = false だけだと :checkhealth lazy が警告を出し続ける)
  rocks = {
    enabled = false,
  },
  performance = {
    cache = {
      enabled = true,
    }
  }
}

require('lazy').setup('plugins', opts)
