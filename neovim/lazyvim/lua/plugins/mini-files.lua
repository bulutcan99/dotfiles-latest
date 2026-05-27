return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
        replace_netrw = false,
      },
    },
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },
  {
    "nvim-mini/mini.files",
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "<CR>", function()
            require("mini.files").go_in({ close_on_file = true })
          end, { buffer = args.data.buf_id, desc = "Open file and close mini.files" })
        end,
      })
    end,
    opts = {
      options = {
        use_as_default_explorer = true,
      },
    },
  },
}
