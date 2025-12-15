-- ============================================================================
-- NEOVIM CONFIG FOR GO DEVELOPMENT
-- ============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add Go bin directory to PATH for tools like goimports, gopls, etc.
local gopath = vim.fn.expand("$HOME/go/bin")
if vim.fn.isdirectory(gopath) == 1 then
  vim.env.PATH = gopath .. ":" .. vim.env.PATH
end

-- Load configurations
require("config.options")
require("config.keymaps")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
