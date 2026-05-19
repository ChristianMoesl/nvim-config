local M = {}

---@class AsyncExecuteOpts
---@field notify_start? string   Message shown immediately when the job starts

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

  if opts.notify_start then
    vim.notify(opts.notify_start, vim.log.levels.INFO)
  end

  ---@diagnostic disable-next-line: missing-fields
  Job:new({
    enable_recording = true,
    command = command,
    args = args,
    on_exit = function(job, return_val)
      local level
      if return_val == 0 then
        level = vim.log.levels.INFO
      else
        level = vim.log.levels.ERROR
      end
      local msg = table.concat(job:result(), "\n") .. table.concat(job:stderr_result(), "\n")
      vim.schedule(function()
        vim.notify(msg, level)
      end)
    end,
  }):start()
end

return M
