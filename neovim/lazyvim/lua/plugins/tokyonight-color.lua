return {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = false,
    enabled = true,
    version = "*",
    init = function()
        vim.cmd.colorscheme("tokyonight")
    end,
    opts = {
        style = "night",
        transparent = true,
        terminal_colors = true,
        styles = {
            comments = { italic = true },
            keywords = { italic = false },
            functions = {},
            variables = {},
            sidebars = "transparent",
            floats = "transparent",
        },
        dim_inactive = false,
        lualine_bold = true,
        cache = true,
        on_colors = function(colors) end,
        on_highlights = function(highlights, colors) end,
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
    end,
}
