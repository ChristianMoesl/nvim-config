local chats_directory = vim.fn.expand("$HOME/.local/share/nvim/parrot/chats/")

local function open_chat()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buffer)
    if name:find("^" .. chats_directory) ~= nil then
      vim.api.nvim_win_set_buf(0, buffer)
      return
    end
  end
  vim.cmd("AiChatFinder")
end

return {
  {
    "frankroeder/parrot.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      "rcarriga/nvim-notify",
    },
    keys = {
      {
        "<A-u>",
        open_chat,
        desc = "Navigate to AI Chat",
      },
      {
        "<leader>a",
        "<cmd>AiChatFinder<CR>",
        desc = "AI Chat",
      },
    },
    opts = function()
      return {
        cmd_prefix = "Ai",
        providers = {
          -- anthropic = {
          --   api_key = os.getenv("ANTHROPIC_API_KEY"),
          -- },
          -- gemini = {
          --   api_key = os.getenv("GEMINI_API_KEY"),
          -- },
          openai = {
            api_key = os.getenv("OPENAI_API_KEY"),
          },
        },
      }
    end,
  },
}
