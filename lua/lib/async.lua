local M = {}

local SPINNER_FRAMES = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

---@class AsyncExecuteOpts
---@field notify_start? string   Message shown as a spinner while the job runs

---@param command_args string|string[]
---@param opts? AsyncExecuteOpts
function M.execute(command_args, opts)
  local Job = require("plenary.job")
  opts = opts or {}

  local command
  local args
  if type(command_args) == "string" then
    command = "zsh"
    args = { "-c", command_args }
  elseif type(command_args) == "table" then
    command = command_args[1]
    ---@diagnostic disable-next-line: deprecated
    args = table.move(command_args, 2, #command_args, 1, {})
  end

  -- Unique notification ID so Snacks can replace it in-place
  local notify_id = "async_execute_" .. tostring(vim.uv.hrtime())
  local timer = nil
  local frame_idx = 1

  if opts.notify_start then
    local base_msg = opts.notify_start
    vim.notify(SPINNER_FRAMES[frame_idx] .. " " .. base_msg, vim.log.levels.INFO, { id = notify_id })

    timer = vim.uv.new_timer()
    timer:start(
      80,
      80,
      vim.schedule_wrap(function()
        frame_idx = (frame_idx % #SPINNER_FRAMES) + 1
        vim.notify(SPINNER_FRAMES[frame_idx] .. " " .. base_msg, vim.log.levels.INFO, { id = notify_id })
      end)
    )
  end

  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    enable_recording = true,
    command = command,
    args = args,
    on_exit = function(job, return_val)
      vim.schedule(function()
        -- Stop the spinner
        if timer then
          timer:stop()
          timer:close()
          timer = nil
        end

        local level = return_val == 0 and vim.log.levels.INFO or vim.log.levels.ERROR

        -- Build message; fall back so we never notify with an empty string
        local result = table.concat(job:result(), "\n"):gsub("^%s*(.-)%s*$", "%1")
        local stderr = table.concat(job:stderr_result(), "\n"):gsub("^%s*(.-)%s*$", "%1")
        local msg = result ~= "" and result
          or (stderr ~= "" and stderr)
          or (return_val == 0 and "✓ Done" or "✗ Failed (exit " .. return_val .. ")")

        vim.notify(msg, level, { id = notify_id })
      end)
    end,
  }):start()
end

return M
