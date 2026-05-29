return {
  -- nvim-cmp ayarlarını zorla güncelle
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "nvim_lsp", priority = 1000 },
      }))
    end,
  },
  -- Rust LSP (rustaceanvim) ayarları
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        on_attach = function(client, bufnr)
          -- Tamamlamayı zorla aktif et
          if client.server_capabilities.completionProvider then
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
          end
        end,
        default_settings = {
          ["rust-analyzer"] = {
            completion = {
              callable = { snippets = "fill_arguments" },
            },
          },
        },
      },
    },
  },
}
