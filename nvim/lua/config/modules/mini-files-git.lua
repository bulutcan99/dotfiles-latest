local M = {}

M.setup = function()
  local mini_files = require("mini.files")
  local ns = vim.api.nvim_create_namespace("mini_files_git")
  local cache = {}
  local cache_timeout_ms = 2000

  local function is_symlink(path)
    local stat = vim.uv.fs_lstat(path)
    return stat and stat.type == "link"
  end

  local function map_symbols(status, symlink)
    local status_map = {
      [" M"] = { symbol = "M", hl_group = "MiniDiffSignChange" },
      ["M "] = { symbol = "M", hl_group = "MiniDiffSignChange" },
      ["MM"] = { symbol = "M", hl_group = "MiniDiffSignChange" },
      ["A "] = { symbol = "+", hl_group = "MiniDiffSignAdd" },
      ["D "] = { symbol = "-", hl_group = "MiniDiffSignDelete" },
      ["R "] = { symbol = "R", hl_group = "MiniDiffSignChange" },
      ["??"] = { symbol = "?", hl_group = "MiniDiffSignDelete" },
      ["!!"] = { symbol = "!", hl_group = "MiniDiffSignChange" },
    }

    local result = status_map[status] or { symbol = "?", hl_group = "NonText" }
    return (symlink and "L" or "") .. result.symbol, symlink and "MiniDiffSignDelete" or result.hl_group
  end

  local function parse_git_status(content)
    local map = {}
    for line in content:gmatch("[^\r\n]+") do
      local status, file_path = line:match("^(..)%s+(.*)")
      if status and file_path then
        local current = ""
        for part in file_path:gmatch("[^/]+") do
          current = current == "" and part or (current .. "/" .. part)
          map[current] = map[current] or status
        end
      end
    end
    return map
  end

  local function update_buffer(buf_id, status_map)
    if not vim.api.nvim_buf_is_valid(buf_id) then
      return
    end

    vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
    local root = vim.fs.root(vim.uv.cwd(), ".git")
    if not root then
      return
    end

    for line = 1, vim.api.nvim_buf_line_count(buf_id) do
      local entry = mini_files.get_fs_entry(buf_id, line)
      if not entry then
        break
      end

      local relative = vim.fs.relpath(root, entry.path)
      local status = relative and status_map[relative]
      if status then
        local symbol, hl_group = map_symbols(status, is_symlink(entry.path))
        vim.api.nvim_buf_set_extmark(buf_id, ns, line - 1, 0, {
          sign_text = symbol,
          sign_hl_group = hl_group,
          priority = 2,
        })
      end
    end
  end

  local function refresh(buf_id)
    local cwd = vim.uv.cwd()
    if not cwd or not vim.fs.root(cwd, ".git") then
      return
    end

    local now = vim.uv.now()
    local cached = cache[cwd]
    if cached and now - cached.time < cache_timeout_ms then
      update_buffer(buf_id, cached.status_map)
      return
    end

    vim.system({ "git", "status", "--ignored", "--porcelain=v1" }, {
      cwd = cwd,
      text = true,
    }, function(result)
      if result.code ~= 0 then
        return
      end

      local status_map = parse_git_status(result.stdout or "")
      cache[cwd] = { time = now, status_map = status_map }
      vim.schedule(function()
        update_buffer(buf_id, status_map)
      end)
    end)
  end

  local group = vim.api.nvim_create_augroup("MiniFilesGitStatus", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      refresh(vim.api.nvim_get_current_buf())
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesBufferUpdate",
    callback = function(args)
      local buf_id = args.data and args.data.buf_id
      if buf_id then
        refresh(buf_id)
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesExplorerClose",
    callback = function()
      cache = {}
    end,
  })
end

return M
