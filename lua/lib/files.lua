local M = {}

local function file_exists(name)
  if vim.uv.fs_stat(name) then
    return true
  end
  return false
end

-- Ensure the path has a trailing slash
local function ensure_trailing_slash(path)
  if not path:match("[/\\]$") then
    return path .. "/"
  end
  return path
end

local function find_local_project_root_(current_dir, root_dir, filenames)
  current_dir = ensure_trailing_slash(current_dir)
  root_dir = ensure_trailing_slash(root_dir)

  -- Loop upwards until we reach the root directory or filesystem root
  while current_dir and current_dir:len() >= root_dir:len() do
    for _, filename in ipairs(filenames) do
      local file_to_check = current_dir .. filename
      if file_exists(file_to_check) then
        -- If found, return the path immediately
        return current_dir
      end
    end

    -- Move to the parent directory
    local parent_dir = current_dir:match("(.*[/\\]).-[/\\]$")
    if parent_dir == current_dir then
      -- Reached the top, break the loop
      return current_dir
    end
    current_dir = parent_dir
  end

  return root_dir
end

function M.find_local_project_root()
  local current_dir = require("oil").get_current_dir() or vim.uv.fs_realpath(vim.fn.expand("%:p:h"))
  local parent = LazyVim.root()

  local res = find_local_project_root_(current_dir, parent, { "package.json", "project.json", "nx.json", ".git" })
  print(res)

  return res
end

return M
