local M = {}

function M.is_minimum_profile() return os.getenv("NVIM_PROFILE") == "MINIMUM" end
function M.is_full_profile() return not M.is_minimum_profile() end

return M
