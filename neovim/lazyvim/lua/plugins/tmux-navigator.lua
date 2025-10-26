return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
    },
    keys = {
        {
            "<c-h>",
            "<cmd>TmuxNavigateLeft<cr>",
            desc = "Navigate to the left pane",
        },
        {
            "<c-j>",
            "<cmd>TmuxNavigateDown<cr>",
            desc = "Navigate to the lower pane",
        },
        {
            "<c-k>",
            "<cmd>TmuxNavigateUp<cr>",
            desc = "Navigate to the upper pane",
        },
        {
            "<c-l>",
            "<cmd>TmuxNavigateRight<cr>",
            desc = "Navigate to the right pane",
        },
        {
            "<c-\\>",
            "<cmd>TmuxNavigatePrevious<cr>",
            desc = "Navigate to the previous pane",
        },
    },
    lazy = false,
}
