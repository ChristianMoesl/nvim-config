return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-vitest"))
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          -- Adapt config file resolving for NX monorepos
          jestConfigFile = function(file)
            local lspconfig = require("lspconfig")
            local nx_project_path = lspconfig.util.root_pattern("project.json")(file)
            local node_project_path = lspconfig.util.root_pattern("package.json")(file)

            local search_config_file = function(path)
              if path == nil then
                return nil
              end
              if vim.uv.fs_stat(path .. "/jest.config.ts") then
                return path .. "/jest.config.ts"
              end
              return path .. "/jest.config.js"
            end

            return search_config_file(nx_project_path) or search_config_file(node_project_path)
          end,
        })
      )
    end,
  },
}
