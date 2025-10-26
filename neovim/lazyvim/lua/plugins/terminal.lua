return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local toggleterm = require("toggleterm")
        local Terminal = require("toggleterm.terminal").Terminal

        toggleterm.setup({
            direction = "float",
            float_opts = {
                border = "curved",
                width = function()
                    return vim.o.columns
                end,
                height = function()
                    return vim.o.lines
                end,
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        })

        -- 1 numaralı terminali elle tanımlıyoruz
        local main_term = Terminal:new({ id = 1 })

        -- CTRL+P ile toggle ediyoruz
        vim.keymap.set("n", "<C-p>", function()
            main_term:toggle()
        end, { noremap = true, silent = true })

        -- Akıllı kapatma
        local function smart_kill_terminal()
            if vim.bo.buftype == "terminal" then
                vim.cmd("bdelete!")
            else
                for _, term in ipairs(require("toggleterm.terminal").get_all()) do
                    if term:is_open() then
                        term:close()
                    end
                end
            end
        end

        vim.keymap.set(
            "n",
            "<C-a>",
            smart_kill_terminal,
            { noremap = true, silent = true }
        )
    end,
}
