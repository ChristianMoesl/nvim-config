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
    if filepath:match("%.[jt]sx?$") or filepath:match("%.[jt]s?$") then
      return true
    end
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

local function isMochaTestFile(filepath)
  -- Return false immediately if the input is not a string.
  if type(filepath) ~= "string" then
    return false
  end

  -- 1. Check if the file is inside a `__tests__` directory.
  -- This pattern handles both Unix-style ('/') and Windows-style ('\') separators.
  if filepath:find("/__tests__/") or filepath:find("\\__tests__\\") then
    if filepath:match("%.[jt]sx?$") or filepath:match("%.[jt]s?$") then
      return true
    end
  end

  -- 2. Check for filename suffixes like `.test.js` or `.spec.tsx`.
  -- The Lua pattern `[jt]sx?$` matches the extensions js, jsx, ts, and tsx.
  -- - `%.`: Matches a literal dot.
  -- - `[jt]`: Matches a single character that is either 'j' or 't'.
  -- - `s`: Matches the literal character 's'.
  -- - `x?`: Matches the literal character 'x' zero or one time (optional).
  -- - `$`: Anchors the pattern to the end of the string.
  if filepath:match("%_spec%.[jt]sx?$") then
    return true
  end

  -- If none of the conditions are met, it's not a Jest test file.
  return false
end

return {
  { "ChristianMoesl/neotest-vitest", branch = "main" },
  -- Bump tsserver memory for large monorepos (e.g. rb3ca-rb3 has ~6500 TS files).
  -- Default is 3072 MB which causes tsserver to OOM-crash on this codebase.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
          },
        },
      },
    },
  },
  -- { "adrigzr/neotest-mocha", branch = "main" },
  -- { "nvim-neotest/neotest-jest", branch = "main" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Treesitter indent for TypeScript is buggy and produces wrong indentation
      -- on new lines. Disabling it makes Neovim fall back to LSP indentation.
      indent = {
        enable = true,
        disable = { "typescript", "tsx" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "ChristianMoesl/neotest-vitest",
      -- "nvim-neotest/neotest-jest",
      -- "adrigzr/neotest-mocha",
    },
    opts = {
      adapters = {
        "neotest-vitest",
        -- "neotest-mocha",
        -- ["neotest-mocha"] = {
        --   command = "node --trace-warnings node_modules/mocha/bin/_mocha --exit --timeout 10000 --require ./src/test/init-mocha -- ",
        --   isTestFile = isMochaTestFile,
        -- },
        -- require("neotest-mocha")({
        --   command = "node --trace-warnings node_modules/mocha/bin/_mocha --exit --timeout 10000 --require ./src/test/init-mocha --",
        --   command_args = function(context)
        --     -- The context contains:
        --     --   results_path: The file that json results are written to
        --     --   test_name: The exact name of the test; is empty for `file` and `dir` position tests.
        --     --   test_name_pattern: The generated pattern for the test
        --     --   path: The path to the test file
        --     --
        --     -- It should return a string array of arguments
        --     --
        --     -- Not specifying 'command_args' will use the defaults below
        --     return {
        --       "--full-trace",
        --       "--reporter=json",
        --       "--reporter-options=output=" .. context.results_path,
        --       "--grep=" .. context.test_name_pattern,
        --       context.path,
        --     }
        --   end,
        --   env = { CI = true },
        --   cwd = function(path)
        --     return vim.fn.getcwd()
        --   end,
        -- }),

        -- ["neotest-jest"] = {
        --   isTestFile = isJestTestFile,
        --   jestConfigFile = findJestConfigFile,
        -- },
      },
    },
  },
}
