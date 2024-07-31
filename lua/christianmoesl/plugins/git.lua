local function toggle_fugitive()
  for _, buf in pairs(vim.fn.getbufinfo()) do
    if buf.name:find("^fugitive://.*/%.git//$") then
      vim.api.nvim_buf_delete(buf.bufnr, {})
      return
    end
  end
  vim.cmd("G")
end

return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    -- dependencies = {
    --   "tpope/vim-rhubarb",
    -- },
    keys = {
      {
        "<leader>go",
        toggle_fugitive,
        desc = "Open Fugitive",
      },
      {
        "<leader>gl",
        "<cmd>G branch --list<CR>",
        desc = "Branch List",
      },
      {
        "<leader>gm",
        "<cmd>G mergetool<CR>",
        desc = "Mergetool",
      },
      {
        "<leader>gcO",
        "<cmd>G checkout --ours -- %<CR>",
        desc = "Choose ours (file)",
      },
      {
        "<leader>gcT",
        "<cmd>G checkout --theirs -- %<CR>",
        desc = "Choose theirs (file)",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    version = "*",
    keys = {
      {
        "<leader>gco",
        "<Plug>(git-conflict-ours)",
        desc = "Choose ours",
      },
      {
        "<leader>gct",
        "<Plug>(git-conflict-theirs)",
        desc = "Choose theirs",
      },
      {
        "<leader>gcb",
        "<Plug>(git-conflict-both)",
        desc = "Choose both",
      },
      {
        "<leader>gc0",
        "<Plug>(git-conflict-none)",
        desc = "Choose none",
      },
      {
        "[x",
        "<Plug>(git-conflict-prev-conflict)",
        desc = "Goto previous Git conflict",
      },
      {
        "]x",
        "<Plug>(git-conflict-next-conflict)",
        desc = "Goto next Git conflict",
      },
    },
    opts = {
      default_mappings = false, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
    },
    config = function(_, opts) require("git-conflict").setup(opts) end,
  },
  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {
      current_line_blame = true,
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- -- Navigation
        -- vim.keymap.set("n", "]c", function()
        --   if vim.wo.diff then
        --     return "]c"
        --   end
        --   vim.schedule(function() gs.next_hunk() end)
        --   return "<Ignore>"
        -- end, { expr = true, desc = "" })
        --
        -- vim.keymap.set("n", "[c", function()
        --   if vim.wo.diff then
        --     return "[c"
        --   end
        --   vim.schedule(function() gs.prev_hunk() end)
        --   return "<Ignore>"
        -- end, { expr = true, desc = "" })

        -- Actions
        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults = vim.list_extend(opts.defaults or {}, {
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>gc", group = "conflicts" },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>gb",
        function() require("telescope.builtin").git_branches() end,
        desc = "Switch Git Branch",
      },
    },
  },
}
