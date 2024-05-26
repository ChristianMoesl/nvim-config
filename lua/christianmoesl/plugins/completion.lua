local cmp_kinds = {
  Text = " ",
  Method = "󰊕 ",
  Function = "󰊕 ",
  Constructor = "󰊕 ",
  Field = "󰰬 ",
  Variable = "󰰬 ",
  Class = "󰯳 ",
  Interface = "󰰅 ",
  Module = " ",
  Property = " ",
  Unit = " ",
  Value = "󰰬 ",
  Enum = "󰯹 ",
  Keyword = " ",
  Snippet = " ",
  Color = " ",
  File = " ",
  Reference = "󰰠 ",
  Folder = " ",
  EnumMember = "󰯹 ",
  Constant = "󰯳 ",
  Struct = " ",
  Event = " ",
  Operator = " ",
  TypeParameter = " ",
  Copilot = " ",
}
return {
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "zbirenbaum/copilot-cmp",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")

      local sorting = defaults.sorting
      ---@diagnostic disable-next-line: need-check-nil
      table.insert(sorting.comparators, 1, require("copilot_cmp.comparators").prioritize)

      return {
        completion = {
          completopt = "menu,menuone,noinsert",
          keyword_length = 1,
        },
        performance = {
          debounce = 150,
          throttle = 75,
          max_view_entries = 30,
        },
        matching = {
          disallow_fuzzy_matching = false,
          disallow_fullfuzzy_matching = false,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-CR>"] = function(fallback) -- Close auto completion window
            cmp.abort()
            fallback()
          end,
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = sorting,
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(_, vim_item)
            vim_item.kind = cmp_kinds[vim_item.kind] or ""
            return vim_item
          end,
        },
      }
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end
      require("cmp").setup(opts)
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },
}
