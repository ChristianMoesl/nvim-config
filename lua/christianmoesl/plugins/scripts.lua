---@class Pr
---@field id number
---@field title string
---@field author string
---@field branch_ref string

---@class PrEntry
---@field value Pr
---@field display (fun(entry: Pr): any)
---@field ordinal string

---@return Pr[]
local function fetch_github_prs()
  local Job = require("plenary.job")
  local job = Job:new({
    enable_recording = true,
    command = "gh",
    args = {
      "pr",
      "list",
      "--json",
      "number,title,headRefName,author",
    },
  })
  job:sync()
  local body = table.concat(job:result(), "\n")
  local prs = vim.json.decode(body)

  if not prs then
    error("Failed to fetch list of PRs with gh CLI tool")
  end

  ---@type Pr[]
  local mapped = {}
  for i, pr in ipairs(prs) do
    mapped[i] = {
      id = pr.number,
      title = pr.title,
      author = pr.author.login,
      branch_ref = pr.headRefName,
    }
  end
  return mapped
end

local function create_pr_previewer()
  local previewers = require("telescope.previewers")
  return previewers.new_termopen_previewer({
    ---@param entry PrEntry
    get_command = function(entry, _) return { "gh", "pr", "view", entry.value.id } end,
  })
end

---@return fun(pr: Pr): PrEntry
local function create_entry_maker()
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 5 },
      { width = 10 },
      { remaining = true },
    },
  })

  ---@param entry PrEntry
  local make_display = function(entry)
    return displayer({
      { "#" .. entry.value.id, "TelescopeResultsIdentifier" },
      { entry.value.author, "TelescopePreviewUser" },
      { entry.value.title, "TelescopePreviewTitle" },
    })
  end

  return function(pr)
    return {
      value = pr,
      display = make_display,
      ordinal = pr.id .. " " .. pr.author .. " " .. pr.title,
    }
  end
end

---@param prompt_bufnr number
local function switch_branch(prompt_bufnr)
  local Job = require("plenary.job")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  actions.close(prompt_bufnr)

  ---@type PrEntry
  local selection = action_state.get_selected_entry()

  Job:new({
    command = "gh",
    args = {
      "pr",
      "checkout",
      selection.value.branch_ref,
    },
    on_exit = function(_, return_val)
      if return_val == 0 then
        vim.notify("Switched to branch " .. selection.value.branch_ref, vim.log.levels.INFO)
      else
        vim.notify(
          "Failed to switch to branch " .. selection.value.branch_ref,
          vim.log.levels.ERROR
        )
      end
    end,
  }):start()
end

---@param opts table?
local function switch_pr(opts)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")

  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Github PRs",
      finder = finders.new_table({
        results = fetch_github_prs(),
        entry_maker = create_entry_maker(),
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function() switch_branch(prompt_bufnr) end)
        return true
      end,
    })
    :find()
end

---@param command_args string|string[]
local function execute(command_args)
  local Job = require("plenary.job")

  local command
  local args
  if type(command_args) == "string" then
    command = "zsh"
    args = { "-c", command_args }
  elseif type(command_args) == "table" then
    command = command_args[1]
    ---@diagnostic disable-next-line: deprecated
    args = table.move(command_args, 2, #command_args, 1, {})
  end

  Job:new({
    enable_recording = true,
    command = command,
    args = args,
    on_exit = function(job, return_val)
      local level
      if return_val == 0 then
        level = vim.log.levels.INFO
      else
        level = vim.log.levels.ERROR
      end
      local msg = table.concat(job:result(), "\n") .. table.concat(job:stderr_result(), "\n")
      vim.notify(msg, level)
    end,
  }):start()
end

local function create_and_switch_branch()
  vim.ui.input({ prompt = "New Branch Name: " }, function(input)
    if input then
      if string.len(input) == 0 then
        vim.notify("Failed to create branch without name", vim.log.levels.ERROR)
      else
        execute({ "git", "switch", "--create", input })
      end
    end
  end)
end

local random = math.random
local seconds = vim.loop.gettimeofday()
if seconds == nil then
  error("could not get time of day")
end
math.randomseed(seconds)

local function objectId()
  local template = "xxxxxxxxxxxxxxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
end

--- @param f (fun(): string)
local function insert(f)
  -- TODO: replace in v-mode
  -- if vim.fn.mode() == "v" then
  --   local vstart = vim.fn.getpos("'<")
  --   local vend = vim.fn.getpos("'>")
  --   local bufnr = vim.api.nvim_win_get_buf(0)
  --   vim.api.nvim_buf_set_lines(bufnr, start, end_, strict_indexing, replacement)
  -- else
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. f() .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
  -- end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>io",
        function() insert(objectId) end,
        desc = "Insert random ObjectId",
      },
      {
        "<leader>iu",
        ":r! uuid<cr>",
        desc = "Insert random UUID",
      },
      {
        "<leader>gv",
        function() execute({ "gh", "browse" }) end,
        desc = "Browse GitHub repo",
      },
      {
        "<leader>gP",
        "<cmd>G push<cr>",
        desc = "Push to remote",
      },
      {
        "<leader>gu",
        "<cmd>G pull<cr>",
        desc = "Pull from remove",
      },
      {
        "<leader>gpc",
        function() execute("gprc") end,
        desc = "Create draft pull request",
      },
      {
        "<leader>grm",
        function() execute("grchanges") end,
        desc = "Rebase on main branch",
      },
      {
        "<leader>gps",
        function() switch_pr({ previewer = create_pr_previewer() }) end,
        desc = "Switch GitHub PR",
      },
      {
        "<leader>gpr",
        function() execute("gprmr") end,
        desc = "Make pull request ready for my team",
      },
      {
        "<leader>gpR",
        function() execute("gprmR") end,
        desc = "Make pull request ready for everyone",
      },
      {
        "<leader>gpv",
        function() execute({ "gh", "pr", "view", "--web" }) end,
        desc = "View Pull Request in web browser",
      },
      {
        "<leader>gdc",
        function() execute("gbgc") end,
        desc = "GC merged branches",
      },
      {
        "<leader>gdC",
        function() execute("greset") end,
        desc = "GC local branches without remote",
      },
      {
        "<leader>gB",
        create_and_switch_branch,
        desc = "Create and switch branch",
      },
      {
        "<leader>xa",
        function()
          vim.diagnostic.setqflist()
          vim.cmd("Cfilter! /build\\/openApi\\//")
        end,
        desc = "All diagnostics",
      },
      {
        "<leader>xw",
        function()
          vim.diagnostic.setqflist({
            severity = {
              max = vim.diagnostic.severity.WARN,
            },
          })
          vim.cmd("Cfilter! /build\\/openApi\\//")
        end,
        desc = "Warning diagnostics",
      },
      {
        "<leader>xe",
        function()
          vim.diagnostic.setqflist({
            severity = {
              min = vim.diagnostic.severity.ERROR,
            },
          })
          vim.cmd("Cfilter! /build\\/openApi\\//")
        end,
        desc = "Error diagnostics",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>gd"] = { name = "+delete" },
        ["<leader>gr"] = { name = "+rebase" },
        ["<leader>gp"] = { name = "+pull request" },
      },
    },
  },
}
