-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local execute = require("lib.async").execute

-- File Navigation
vim.keymap.set("n", "<leader>by", '<cmd>let @+ = expand("%:p")<cr>', { desc = "Yank File Path of Buffer" })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

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

-- Git Mappings

vim.keymap.set("n", "<leader>gpv", function()
  execute({ "gh", "pr", "view", "--web" })
end, { desc = "View Pull Request in web browser" })

vim.keymap.set("n", "<leader>gv", function()
  execute({ "gh", "browse" })
end, { desc = "Browse GitHub repo" })

vim.keymap.set("n", "<leader>gP", "<cmd>G push<cr>", { desc = "Push to remote" })
vim.keymap.set("n", "<leader>gU", "<cmd>G pull<cr>", { desc = "Pull from remove" })

vim.keymap.set("n", "<leader>gpc", function()
  execute("gprc")
end, { desc = "Create draft pull request" })

vim.keymap.set("n", "<leader>gpr", function()
  execute("gprmr")
end, { desc = "Make pull request ready for my team" })

vim.keymap.set("n", "<leader>gdC", function()
  execute("greset")
end, { desc = "GC local branches without remote" })

vim.keymap.set("n", "<leader>gps", function()
  local github = require("lib.github")
  github.switch_pr({ previewer = github.create_pr_previewer() })
end, { desc = "Switch GitHub PR" })

-- Generate random Data

vim.keymap.set("n", "<leader>cgo", function()
  local generate = require("lib.generate")
  generate.insert(generate.objectId)
end, { desc = "Generate random ObjectId" })

vim.keymap.set("n", "<leader>cgu", ":r! uuid<cr>", { desc = "Generate random UUID" })
