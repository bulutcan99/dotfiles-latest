local M = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function shell_open(path)
  if vim.fn.has("mac") == 1 then
    vim.system({ "open", path }, { detach = true })
    return
  end

  if vim.fn.has("win32") == 1 then
    vim.system({ "cmd", "/c", "start", "", path }, { detach = true })
    return
  end

  vim.system({ "xdg-open", path }, { detach = true })
end

local function clipboard_set(value)
  vim.fn.setreg("+", value)
  vim.fn.setreg("*", value)
end

local function home_relative(path)
  local home = vim.fn.expand("~")
  if path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

M.setup = function(opts)
  local mini_files = require("mini.files")
  local keymaps = opts.custom_keymaps or {}
  local group = vim.api.nvim_create_augroup("MiniFilesCustomKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data and args.data.buf_id
      if not buf_id then
        return
      end

      local function map(lhs, rhs, desc)
        if not lhs or lhs == "" then
          return
        end
        vim.keymap.set("n", lhs, rhs, {
          buffer = buf_id,
          desc = desc,
          noremap = true,
          silent = true,
        })
      end

      map(keymaps.open_tmux_pane, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if not entry or entry.fs_type ~= "directory" then
          notify("Not a directory or no entry selected", vim.log.levels.WARN)
          return
        end

        local ok, keymaps_mod = pcall(require, "config.keymaps")
        if ok and type(keymaps_mod.tmux_pane_function) == "function" then
          keymaps_mod.tmux_pane_function(entry.path)
          return
        end

        notify("Tmux pane integration is not configured", vim.log.levels.WARN)
      end, "Open directory in tmux pane")

      map(keymaps.copy_to_clipboard, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if not entry then
          notify("No file or directory selected", vim.log.levels.WARN)
          return
        end
        clipboard_set(entry.path)
        notify("Copied to clipboard")
      end, "Copy file or directory path to clipboard")

      map(keymaps.zip_and_copy, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if not entry then
          notify("No file or directory selected", vim.log.levels.WARN)
          return
        end

        local name = vim.fn.fnamemodify(entry.path, ":t")
        local parent = vim.fn.fnamemodify(entry.path, ":h")
        local zip_path = string.format("/tmp/%s_%s.zip", name, os.date("%y%m%d%H%M%S"))
        local result = vim.system({ "zip", "-r", zip_path, name }, {
          cwd = parent,
          text = true,
        }):wait()

        if result.code ~= 0 then
          notify("Failed to create zip file: " .. (result.stderr or result.stdout or ""), vim.log.levels.ERROR)
          return
        end

        clipboard_set(zip_path)
        notify("Zipped and copied to clipboard")
      end, "Zip entry and copy archive path")

      map(keymaps.paste_from_clipboard, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if not entry then
          notify("Failed to retrieve current entry in mini.files.", vim.log.levels.ERROR)
          return
        end

        local dest_dir = entry.fs_type == "directory" and entry.path or vim.fn.fnamemodify(entry.path, ":h")
        local source = vim.fn.getreg("+")
        if source == "" or vim.uv.fs_stat(source) == nil then
          notify("Clipboard does not contain a valid file or directory.", vim.log.levels.WARN)
          return
        end

        local dest = dest_dir .. "/" .. vim.fn.fnamemodify(source, ":t")
        local cmd = vim.fn.isdirectory(source) == 1 and { "cp", "-R", source, dest } or { "cp", source, dest }
        local result = vim.system(cmd, { text = true }):wait()
        if result.code ~= 0 then
          notify("Paste operation failed: " .. (result.stderr or result.stdout or ""), vim.log.levels.ERROR)
          return
        end

        mini_files.synchronize()
        notify("Pasted successfully.")
      end, "Paste path from clipboard")

      map(keymaps.copy_path, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if not entry then
          notify("No file or directory selected", vim.log.levels.WARN)
          return
        end
        clipboard_set(home_relative(entry.path))
        notify("Path copied to clipboard")
      end, "Copy relative path to clipboard")

      map(keymaps.open_with_default_app, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if entry then
          shell_open(entry.path)
        end
      end, "Open entry with default app")

      map(keymaps.preview_image, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if entry then
          shell_open(entry.path)
        end
      end, "Preview image")

      map(keymaps.preview_image_popup, function()
        local entry = mini_files.get_fs_entry(buf_id)
        if entry then
          shell_open(entry.path)
        end
      end, "Preview image in popup")
    end,
  })
end

return M
