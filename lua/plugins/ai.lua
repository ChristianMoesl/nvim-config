return {
  "folke/sidekick.nvim",
  ---@class sidekick.Config
  opts = {
    cli = {
      ---@type table<string, sidekick.cli.Config|{}>
      tools = {
        copilot = { cmd = { "copilot", "--model", "claude-sonnet-4.6" } },
        opencode = { cmd = { "opencode", "--model", "github-copilot/claude-sonnet-4.6" } },
        -- copilot --help:
        -- "claude-sonnet-4.5", "claude-haiku-4.5", "claude-opus-4.5",
        -- "claude-sonnet-4", "gpt-5.2-codex", "gpt-5.1-codex-max", "gpt-5.1-codex", "gpt-5.2", "gpt-5.1",
        -- "gpt-5", "gpt-5.1-codex-mini", "gpt-5-mini", "gpt-4.1", "gemini-3-pro-preview"
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle("pi")
      end,
      desc = "Sidekick Toggle CLI",
    },
  },
}
