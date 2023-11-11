local Util = require("lazy.core.util")
local b

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
    get_command = function(entry, _)
      return { "gh", "pr", "view", entry.value.id }
    end,
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

  ---@param entry PrEntry keys:
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
        Util.info("Switched to branch " .. selection.value.branch_ref)
      else
        Util.error("Failed to switch to branch " .. selection.value.branch_ref)
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
        actions.select_default:replace(
          function() switch_branch(prompt_bufnr) end
        )
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
      local msg = table.concat(job:result(), "\n")
        .. table.concat(job:stderr_result(), "\n")
      Util.notify(msg, { level = level })
    end,
  }):start()
end

local function create_and_switch_branch()
  vim.ui.input({ prompt = "New Branch Name: " }, function(input)
    if input then
      if string.len(input) == 0 then
        Util.error("Failed to create branch without name")
      else
        execute({ "git", "switch", "--create", input })
      end
    end
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
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
        desc = "Make pull request ready for CDM",
      },
      {
        "<leader>gpR",
        function() execute("gprmrabs") end,
        desc = "Make pull request ready for CDM & ABS",
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
