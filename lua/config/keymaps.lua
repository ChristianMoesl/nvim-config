-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- Diagnostic Mappings
local filter_and_report = function(level)
  vim.cmd("Cfilter! /build\\/openApi\\//")
  local items = vim.fn.len(vim.fn.getqflist())
  if items == 0 then
    vim.notify("No " .. level .. "diagnostics found", vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>xa", function()
  vim.diagnostic.setqflist()
  filter_and_report("")
end, { desc = "All diagnostics" })

vim.keymap.set("n", "<leader>xi", function()
  vim.diagnostic.setqflist({
    ---@diagnostic disable-next-line: assign-type-mismatch
    severity = {
      min = vim.diagnostic.severity.INFO,
      max = vim.diagnostic.severity.INFO,
    },
  })
  filter_and_report("info ")
end, { desc = "Info diagnostics" })

vim.keymap.set("n", "<leader>xw", function()
  vim.diagnostic.setqflist({
    ---@diagnostic disable-next-line: assign-type-mismatch
    severity = {
      min = vim.diagnostic.severity.WARN,
      max = vim.diagnostic.severity.WARN,
    },
  })
  filter_and_report("warning ")
end, { desc = "Warning diagnostics" })

vim.keymap.set("n", "<leader>xe", function()
  vim.diagnostic.setqflist({
    ---@diagnostic disable-next-line: assign-type-mismatch
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
  })
  filter_and_report("error ")
end, { desc = "Error diagnostics" })
