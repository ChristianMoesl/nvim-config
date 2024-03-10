return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    version = false,
    lazy = false,
    dependencies = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    lazy = false,
    build = ":TSUpdate",
    opts = {
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "html",
        "json",
        "dockerfile",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "yaml",
        "csv",
        "tsv",
        "xml",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },
}
