local M = {}

local function find_common_prefix(paths)
  if #paths == 0 then
    return ""
  end

  if #paths == 1 then
    return paths[1]:match("^(.*/)") or ""
  end

  local common_prefix = paths[1]
  for i = 2, #paths do
    while #common_prefix > 0 and not paths[i]:find("^" .. vim.pesc(common_prefix)) do
      common_prefix = common_prefix:match("^(.*/)")
      if not common_prefix then
        return ""
      end
    end
  end

  -- Ensure we end at a directory boundary
  common_prefix = common_prefix:match("^(.*/)") or ""

  return common_prefix
end

function M.get_worktrees()
  local handle = io.popen("git worktree list --porcelain 2>/dev/null")
  if not handle then
    return {}
  end

  local result = handle:read("*a")
  handle:close()

  if result == "" then
    return {}
  end

  local worktrees = {}
  local current = {}

  for line in (result .. "\n"):gmatch("([^\n]*)\n") do
    if line:match("^worktree ") then
      current.path = line:match("^worktree (.+)$")
    elseif line:match("^branch ") then
      current.branch = line:match("^branch refs/heads/(.+)$")
    elseif line == "" and current.path then
      table.insert(worktrees, current)
      current = {}
    end
  end

  if current.path then
    table.insert(worktrees, current)
  end

  return worktrees
end

function M.switch_worktree()
  local worktrees = M.get_worktrees()

  if #worktrees == 0 then
    vim.notify("No git worktrees found", vim.log.levels.WARN)
    return
  end

  local current_dir = vim.fn.getcwd()

  local paths = vim.tbl_map(function(wt)
    return wt.path
  end, worktrees)
  local common_prefix = find_common_prefix(paths)

  local items = {}

  for _, wt in ipairs(worktrees) do
    local label = wt.path:sub(#common_prefix + 1)
    if label == "" then
      label = wt.path
    end
    if wt.branch then
      label = label .. " [" .. wt.branch .. "]"
    end
    local is_current = wt.path == current_dir
    if is_current then
      label = label .. " (current)"
    end
    table.insert(items, { label = label, path = wt.path, is_current = is_current })
  end

  vim.ui.select(items, {
    prompt = "Select worktree:",
    format_item = function(item)
      return item.label
    end,
    kind = "worktree",
  }, function(choice)
    if choice and choice.path ~= current_dir then
      -- Change to the new worktree directory
      vim.cmd("cd " .. vim.fn.fnameescape(choice.path))

      -- Close all buffers to avoid confusion with files from old worktree
      vim.cmd("only")
      vim.cmd("wa")
      vim.cmd("bufdo bwipeout!")

      -- Refresh oil.nvim if available
      local ok, oil = pcall(require, "oil")
      if ok then
        oil.open(choice.path)
      end

      vim.notify("Switched to: " .. choice.path, vim.log.levels.INFO)
    end
  end)
end

return M
