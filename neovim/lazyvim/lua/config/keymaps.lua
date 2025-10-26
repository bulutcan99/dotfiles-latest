-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Buffer editing
keymap.set("n", "<tab>", function()
    vim.cmd("bnext")
end, { desc = "Go to next buffer" })
keymap.set("n", "<S-tab>", function()
    vim.cmd("bprev")
end, { desc = "Go to previous buffer" })

-- Close all buffers
keymap.set("n", "<leader>bO", function()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    -- Yeni boş bir buffer oluştur
    vim.cmd("enew") -- :enew = boş, yeni bir buffer
end, { desc = "Close ALL buffers and open a new empty buffer" })

-- Marks
vim.keymap.set("n", "dar", function()
    vim.cmd("delm! | delm A-Z0-9")
end, { desc = "Delete all a-z / A-Z marks" })

-- Terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Tüm mark'ları temizle (normal modda)
vim.keymap.set(
    "n",
    "<leader>dm",
    ":delmarks a-z A-Z 0-9<CR>",
    { desc = "Tüm mark'ları sil", noremap = true }
)
