return {
    {
        "bkad/CamelCaseMotion",
        config = function()
            vim.api.nvim_set_keymap(
                "n",
                "w",
                "<Plug>CamelCaseMotion_w",
                { silent = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "b",
                "<Plug>CamelCaseMotion_b",
                { silent = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "e",
                "<Plug>CamelCaseMotion_e",
                { silent = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "ge",
                "<Plug>CamelCaseMotion_ge",
                { silent = true }
            )
        end,
    },
}
