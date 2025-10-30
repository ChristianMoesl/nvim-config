local M = {}

-- Helper function to find the bin directory of the default fnm Node.js version
local function get_fnm_default_bin_path()
  -- This command asks fnm for the path to its default `node` executable,
  -- then uses `sed` to remove the trailing '/bin/node' to get just the directory path.
  local command = "fnm exec --using=default which node | sed 's|/node$||'"

  -- Execute the command and capture its output
  local handle = io.popen(command)
  if not handle then
    return nil
  end
  local path = handle:read("*a")
  handle:close()

  -- Trim whitespace and newline characters from the command's output
  return path:match("^%s*(.-)%s*$")
end

function M.configure_node_environment()
  -- Get the path
  local modern_node_bin_path = get_fnm_default_bin_path()

  -- If a path was successfully found, prepend it to Neovim's PATH
  if modern_node_bin_path and #modern_node_bin_path > 0 then
    vim.env.PATH = modern_node_bin_path .. ":" .. vim.env.PATH
  else
    vim.notify("Could not find a default node version using fnm", vim.log.levels.ERROR)
  end
end

return M
