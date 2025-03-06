local M = {}

local random = math.random
local seconds = vim.uv.gettimeofday()
if seconds == nil then
  error("could not get time of day")
end
math.randomseed(seconds)

function M.objectId()
  local template = "xxxxxxxxxxxxxxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
end

--- @param f (fun(): string)
function M.insert(f)
  -- TODO: replace in v-mode
  -- if vim.fn.mode() == "v" then
  --   local vstart = vim.fn.getpos("'<")
  --   local vend = vim.fn.getpos("'>")
  --   local bufnr = vim.api.nvim_win_get_buf(0)
  --   vim.api.nvim_buf_set_lines(bufnr, start, end_, strict_indexing, replacement)
  -- else
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. f() .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
  -- end
end

return M
