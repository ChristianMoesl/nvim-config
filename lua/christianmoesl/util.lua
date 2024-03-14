local M = {}

---@param name string
function M.file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

function M.is_minimum_profile() return os.getenv("NVIM_PROFILE") == "MINIMUM" end

function M.is_full_profile() return not M.is_minimum_profile() end

return M
