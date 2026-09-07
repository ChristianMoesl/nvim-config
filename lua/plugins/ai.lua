return {
  "folke/sidekick.nvim",
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
