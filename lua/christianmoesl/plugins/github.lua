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

local function build_pr_previewer()
  local previewers = require("telescope.previewers")
  return previewers.new_termopen_previewer({
    get_command = function(entry, _)
      return { "gh", "pr", "view", entry.value[1] }
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
        vim.notify(
          "Switched to branch " .. selection.value.branch_ref,
          vim.log.levels.INFO
        )
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
        actions.select_default:replace(
          function() switch_branch(prompt_bufnr) end
        )
        return true
      end,
    })
    :find()
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>gp",
        function() switch_pr({ previewer = build_pr_previewer() }) end,
        desc = "Switch GitHub PR",
      },
    },
  },
}
