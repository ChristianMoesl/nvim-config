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

local function is_within(path, directory)
  path = vim.fs.normalize(path)
  directory = vim.fs.normalize(directory)
  return path == directory or vim.startswith(path, directory .. "/")
end

local function switch_directory(path)
  vim.cmd("tcd " .. vim.fn.fnameescape(path))

  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open(path)
  end

  vim.notify("Switched to: " .. path, vim.log.levels.INFO)
end

local function pick(items, title)
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("Snacks is not available", vim.log.levels.ERROR)
    return
  end

  snacks.picker({
    title = title,
    finder = function()
      return items
    end,
    format = function(item)
      local marker = item.current and "● " or "  "
      local marker_highlight = item.current and "DiagnosticOk" or "Comment"
      local result = {
        { marker, marker_highlight },
        { item.repository, "Directory" },
      }

      if item.branch then
        table.insert(result, { "  " .. item.branch, "Comment" })
      end
      if item.dirty then
        table.insert(result, { "  dirty", "DiagnosticWarn" })
      end

      return result
    end,
    preview = "none",
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.schedule(function()
          switch_directory(item.path)
        end)
      end
    end,
  })
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

function M.switch_git_worktree()
  local worktrees = M.get_worktrees()

  if #worktrees == 0 then
    vim.notify("No git worktrees found", vim.log.levels.WARN)
    return
  end

  local current_dir = vim.fn.getcwd()
  local paths = vim.tbl_map(function(worktree)
    return worktree.path
  end, worktrees)
  local common_prefix = find_common_prefix(paths)
  local items = {}

  for _, worktree in ipairs(worktrees) do
    local repository = worktree.path:sub(#common_prefix + 1)
    if repository == "" then
      repository = worktree.path
    end

    table.insert(items, {
      text = table.concat({ repository, worktree.branch or "", worktree.path }, " "),
      repository = repository,
      branch = worktree.branch,
      path = worktree.path,
      current = is_within(current_dir, worktree.path),
    })
  end

  pick(items, "Git worktrees")
end

local function pick_radar_repositories(context)
  if not vim.islist(context.members) or #context.members == 0 then
    vim.notify("This Radar workspace has no repositories", vim.log.levels.WARN)
    return
  end

  local current_dir = vim.fn.getcwd()
  local items = {}

  for _, member in ipairs(context.members) do
    local repository = vim.fs.basename(member.repository)
    table.insert(items, {
      text = table.concat({ repository, member.branch or "", member.path }, " "),
      repository = repository,
      branch = member.branch,
      path = member.path,
      dirty = member.dirty,
      current = is_within(current_dir, member.path),
    })
  end

  pick(items, "Radar repositories")
end

function M.switch_worktree()
  if vim.fn.executable("radar") ~= 1 then
    M.switch_git_worktree()
    return
  end

  vim.system({ "radar", "workspace-context", "--workspace", vim.fn.getcwd() }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        if (result.stderr or ""):find("not a flat Radar worktree", 1, true) then
          M.switch_git_worktree()
          return
        end

        local message = vim.trim(result.stderr or "")
        vim.notify(message ~= "" and message or "Could not load the Radar workspace", vim.log.levels.ERROR)
        return
      end

      local ok, context = pcall(vim.json.decode, result.stdout)
      if not ok or type(context) ~= "table" then
        vim.notify("Radar returned invalid workspace context", vim.log.levels.ERROR)
        return
      end

      pick_radar_repositories(context)
    end)
  end)
end

return M
