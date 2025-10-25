-- Jest test files are identified by two main conventions:
-- 1. They are located inside a directory named `__tests__`.
-- 2. Their filename includes `.test` or `.spec` before the extension.
--
-- @param filepath (string) The path to the file to check.
-- @return (boolean) Returns `true` if the path matches Jest conventions, otherwise `false`.
--
local function isJestTestFile(filepath)
  -- Return false immediately if the input is not a string.
  if type(filepath) ~= "string" then
    return false
  end

  -- 1. Check if the file is inside a `__tests__` directory.
  -- This pattern handles both Unix-style ('/') and Windows-style ('\') separators.
  if filepath:find("/__tests__/") or filepath:find("\\__tests__\\") then
    return true
  end

  -- 2. Check for filename suffixes like `.test.js` or `.spec.tsx`.
  -- The Lua pattern `[jt]sx?$` matches the extensions js, jsx, ts, and tsx.
  -- - `%.`: Matches a literal dot.
  -- - `[jt]`: Matches a single character that is either 'j' or 't'.
  -- - `s`: Matches the literal character 's'.
  -- - `x?`: Matches the literal character 'x' zero or one time (optional).
  -- - `$`: Anchors the pattern to the end of the string.
  if filepath:match("%.spec%.[jt]sx?$") or filepath:match("%.it%.[jt]sx?$") then
    return true
  end

  -- If none of the conditions are met, it's not a Jest test file.
  return false
end

-- Adapt config file resolving for NX monorepos
local function findJestConfigFile(file)
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
end

return {
  { "marilari88/neotest-vitest" },
  { "nvim-neotest/neotest-jest", branch = "main" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          isTestFile = isJestTestFile,
          jestConfigFile = findJestConfigFile,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
              implementationsCodeLens = {
                enabled = true,
                showOnInterfaceMethods = true,
              },
            },
          },
        },
      },
    },
  },
}
