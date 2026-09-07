local M = {}

function M.switch_pr()
  Snacks.picker.gh_pr({
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end

      vim.system({ "gh", "pr", "checkout", tostring(item.number) }, { text = true }, function(result)
        vim.schedule(function()
          local success = result.code == 0
          vim.notify(
            success and "Switched to PR #" .. item.number or vim.trim(result.stderr),
            success and vim.log.levels.INFO or vim.log.levels.ERROR
          )
        end)
      end)
    end,
  })
end

return M
