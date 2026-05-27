return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
      on_highlights = function(hl, colors)
        local transparent = {
          "Normal",
          "NormalNC",
          "SignColumn",
          "FoldColumn",
          "LineNr",
          "LineNrAbove",
          "LineNrBelow",
          "CursorLine",
          "CursorLineNr",
          "EndOfBuffer",
          "StatusLine",
          "StatusLineNC",
          "TabLine",
          "TabLineFill",
          "TabLineSel",
          "WinBar",
          "WinBarNC",
          "WinSeparator",
        }

        for _, group in ipairs(transparent) do
          hl[group] = type(hl[group]) == "table" and hl[group] or {}
          hl[group].bg = "NONE"
        end

        hl.Visual = { bg = colors.bg_visual }
        hl.CursorLine = { bg = "NONE" }
      end,
    },
  },
}
