-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Buffer navigation
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bO", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all other buffers" })

-- Float terminal
local function toggle_float_term()
  Snacks.terminal.toggle()
end

vim.keymap.set("n", "<C-p>", toggle_float_term, { desc = "Toggle float terminal" })
vim.keymap.set({ "n", "t" }, "<C-a>", toggle_float_term, { desc = "Close float terminal" })

-- File explorer
vim.keymap.set("n", "<leader>e", function()
  local root = LazyVim and LazyVim.root and LazyVim.root() or vim.uv.cwd()
  require("mini.files").open(root, true)
end, { desc = "Explorer mini.files (root dir)" })

vim.keymap.set("n", "<leader>E", function()
  local path = vim.api.nvim_buf_get_name(0)
  require("mini.files").open(path ~= "" and path or vim.uv.cwd(), true)
end, { desc = "Explorer mini.files (current file)" })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Search & replace
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Quality of life
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor position)" })
