local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("christianmoesl.config.options")
require("christianmoesl.config.keymaps")

vim.cmd("packadd cfilter")

require("lazy").setup({
  spec = {
    { import = "christianmoesl.plugins" },
    { import = "christianmoesl.plugins.languages" },
  },
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "catppuccin" },
  },
  performance = {
    rtp = {
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
      },
    },
  },
})
