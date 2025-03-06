local M = {}

---@param command_args string|string[]
function M.execute(command_args)
  local Job = require("plenary.job")

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
      vim.notify(msg, level)
    end,
  }):start()
end

return M
