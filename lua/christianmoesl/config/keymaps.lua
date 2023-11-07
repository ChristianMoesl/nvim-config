-- This file is automatically loaded
local Util = require("christianmoesl.util")

-- Resize window using <ctrl> arrow keys
vim.keymap.set(
  "n",
  "<A-Up>",
  "<cmd>resize +2<cr>",
  { desc = "Increase window height" }
)
vim.keymap.set(
  "n",
  "<A-Down>",
  "<cmd>resize -2<cr>",
  { desc = "Decrease window height" }
)
vim.keymap.set(
  "n",
  "<A-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "Decrease window width" }
)
vim.keymap.set(
  "n",
  "<A-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "Increase window width" }
)

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set(
  "n",
  "<C-h>",
  "<C-w>h",
  { desc = "Go to left window", remap = true }
)
vim.keymap.set(
  "n",
  "<C-j>",
  "<C-w>j",
  { desc = "Go to lower window", remap = true }
)
vim.keymap.set(
  "n",
  "<C-k>",
  "<C-w>k",
  { desc = "Go to upper window", remap = true }
)
vim.keymap.set(
  "n",
  "<C-l>",
  "<C-w>l",
  { desc = "Go to right window", remap = true }
)

-- Move Lines
vim.keymap.set("n", "<A-d>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-u>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<A-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("i", "<A-d>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("v", "<A-d>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-u>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set(
  "n",
  "<leader>bb",
  "<cmd>e #<cr>",
  { desc = "Switch to Other Buffer" }
)
vim.keymap.set(
  "n",
  "<leader>`",
  "<cmd>e #<cr>",
  { desc = "Switch to Other Buffer" }
)

-- Clear search with <esc>
vim.keymap.set(
  { "i", "n" },
  "<esc>",
  "<cmd>noh<cr><esc>",
  { desc = "Escape and clear hlsearch" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-nttps://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set(
  "n",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
vim.keymap.set(
  "x",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
vim.keymap.set(
  "o",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
vim.keymap.set(
  "n",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)
vim.keymap.set(
  "x",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)
vim.keymap.set(
  "o",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- if not Util.has("trouble.nvim") then
--  vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
--  vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
-- end

-- toggle options
-- map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
-- map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
-- vim.keymap.set("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
-- map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
-- if vim.lsp.inlay_hint then
--  map("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
-- end

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- floating terminal
local lazyterm = function() Util.float_term(nil, { cwd = Util.get_root() }) end
-- vim.keymap.set("n", "<leader>ft", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set(
  "n",
  "<leader>fT",
  function() Util.float_term() end,
  { desc = "Terminal (cwd)" }
)
vim.keymap.set("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set(
  "t",
  "<C-h>",
  "<cmd>wincmd h<cr>",
  { desc = "Go to left window" }
)
vim.keymap.set(
  "t",
  "<C-j>",
  "<cmd>wincmd j<cr>",
  { desc = "Go to lower window" }
)
vim.keymap.set(
  "t",
  "<C-k>",
  "<cmd>wincmd k<cr>",
  { desc = "Go to upper window" }
)
vim.keymap.set(
  "t",
  "<C-l>",
  "<cmd>wincmd l<cr>",
  { desc = "Go to right window" }
)
-- vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
vim.keymap.set(
  "n",
  "<leader>ww",
  "<C-W>p",
  { desc = "Other window", remap = true }
)
vim.keymap.set(
  "n",
  "<leader>wd",
  "<C-W>c",
  { desc = "Delete window", remap = true }
)
vim.keymap.set(
  "n",
  "<leader>w-",
  "<C-W>s",
  { desc = "Split window below", remap = true }
)
vim.keymap.set(
  "n",
  "<leader>w|",
  "<C-W>v",
  { desc = "Split window right", remap = true }
)
vim.keymap.set(
  "n",
  "<leader>-",
  "<C-W>s",
  { desc = "Split window below", remap = true }
)
vim.keymap.set(
  "n",
  "<leader>|",
  "<C-W>v",
  { desc = "Split window right", remap = true }
)
