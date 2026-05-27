-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.pumblend = 5
vim.opt.winblend = 5

if vim.g.neovide then
  vim.g.neovide_opacity = 0.85
  vim.g.neovide_normal_opacity = 0.85
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end
