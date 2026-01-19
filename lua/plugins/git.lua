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
        "<leader>gw",
        "<cmd>Gwrite<CR>",
        desc = "Write (stage file)",
      },
      {
        "<leader>gmt",
        "<cmd>G mergetool<CR>",
        desc = "Mergetool",
      },
      {
        "<leader>gmc",
        "<cmd>G merge --continue<CR>",
        desc = "Merge Continue",
      },
      {
        "<leader>gma",
        "<cmd>G merge --abort<CR>",
        desc = "Merge Abort",
      },
      {
        "<leader>grc",
        "<cmd>G rebase --continue<CR>",
        desc = "Rebase Continue",
      },
      {
        "<leader>gra",
        "<cmd>G rebase --abort<CR>",
        desc = "Rebase Abort",
      },
      {
        "<leader>rfO",
        "<cmd>G checkout --ours -- %<CR>",
        desc = "Choose ours (file)",
      },
      {
        "<leader>rfT",
        "<cmd>G checkout --theirs -- %<CR>",
        desc = "Choose theirs (file)",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      {
        "<leader>ro",
        "<Plug>(git-conflict-ours)",
        desc = "Choose ours",
      },
      {
        "<leader>rt",
        "<Plug>(git-conflict-theirs)",
        desc = "Choose theirs",
      },
      {
        "<leader>rb",
        "<Plug>(git-conflict-both)",
        desc = "Choose both",
      },
      {
        "<leader>r0",
        "<Plug>(git-conflict-none)",
        desc = "Choose none",
      },
      {
        "[r",
        "<Plug>(git-conflict-prev-conflict)",
        desc = "Goto previous Resolvable Git conflict",
      },
      {
        "]r",
        "<Plug>(git-conflict-next-conflict)",
        desc = "Goto next Resolvable Git conflict",
      },
    },
    opts = {
      default_mappings = false, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = vim.list_extend(opts.spec or {}, {
        { "<leader>gd", group = "Delete" },
        { "<leader>gp", group = "Pull Requests" },
        { "<leader>gm", group = "Merge" },
        { "<leader>gr", group = "Rebase" },
        { "<leader>r", group = "Resolve Conflicts" },
        { "<leader>rf", group = "File" },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>gl",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "List Git Branches",
      },
    },
  },
}
