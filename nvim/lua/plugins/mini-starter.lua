return {
  {
    "nvim-mini/mini.starter",
    opts = function(_, opts)
      local starter = require("mini.starter")
      local keys = {
        ["Find file"] = "f",
        ["New file"] = "n",
        ["Recent files"] = "r",
        ["Find text"] = "g",
        ["Projects"] = "p",
        ["Projects (util.project)"] = "u",
        ["Config"] = "c",
        ["Restore session"] = "s",
        ["Lazy Extras"] = "x",
        ["Lazy"] = "l",
        ["Quit"] = "q",
      }

      for _, item in ipairs(opts.items or {}) do
        if type(item) == "table" and type(item.name) == "string" then
          local key = keys[item.name]
          if key and not item.name:match("^%w%s*│") then
            item.name = key .. " │ " .. item.name
          end
        end
      end

      opts.content_hooks = {
        starter.gen_hook.adding_bullet(string.rep(" ", 22), false),
        starter.gen_hook.aligning("center", "center"),
      }
    end,
  },
}
