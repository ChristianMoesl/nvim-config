local plugin_dir = "/Users/Christian.Moesl/workspace/radar.nvim"
local radar_bin = plugin_dir .. "/radar"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "radar.nvim" })
end

local function setup_radar()
  require("radar").setup({
    radar_cmd = radar_bin,
  })
end

local function reload_radar()
  notify("Reloading radar.nvim…")
  vim.system({ "go", "build", "-o", "radar", "./cmd/radar" }, { cwd = plugin_dir, text = true }, function(build_result)
    vim.schedule(function()
      if build_result.code ~= 0 then
        local output = (build_result.stderr and build_result.stderr ~= "" and build_result.stderr)
          or build_result.stdout
          or "unknown error"
        notify("Failed to build radar\n" .. output, vim.log.levels.ERROR)
        return
      end

      local loaded, radar = pcall(require, "radar")
      if loaded and radar.teardown then
        pcall(radar.teardown)
      end
      package.loaded["radar"] = nil

      vim.system({ radar_bin, "restart" }, { text = true }, function(restart_result)
        vim.schedule(function()
          if restart_result.code ~= 0 then
            local output = (restart_result.stderr and restart_result.stderr ~= "" and restart_result.stderr)
              or restart_result.stdout
              or "unknown error"
            notify("Failed to restart radar daemon\n" .. output, vim.log.levels.ERROR)
            return
          end

          local ok, reloaded = pcall(require, "radar")
          if not ok then
            notify("Failed to reload radar.nvim\n" .. tostring(reloaded), vim.log.levels.ERROR)
            return
          end

          reloaded.setup({
            radar_cmd = radar_bin,
          })
          vim.defer_fn(function()
            require("radar").refresh()
          end, 300)
          notify("Reloaded radar.nvim, rebuilt binary, and restarted daemon")
        end)
      end)
    end)
  end)
end

return {
  {
    dir = plugin_dir,
    name = "radar.nvim",
    lazy = false,
    build = "go build -o radar ./cmd/radar",
    cmd = { "Radar", "RadarRefresh", "RadarStart", "RadarStop", "RadarRestart" },
    keys = {
      {
        "<leader>mm",
        function()
          require("radar").open()
        end,
        desc = "Open Radar",
      },
      {
        "<leader>mr",
        function()
          require("radar").refresh()
        end,
        desc = "Refresh Radar",
      },
      {
        "<leader>ml",
        reload_radar,
        desc = "Reload Radar",
      },
    },
    config = function()
      setup_radar()

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("RadarNvimDevReload", { clear = true }),
        pattern = plugin_dir .. "/lua/radar/*.lua",
        callback = reload_radar,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, {
        function()
          return require("radar").statusline()
        end,
        cond = function()
          return package.loaded["radar"] ~= nil
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts.spec = vim.list_extend(opts.spec or {}, {
        { "<leader>m", group = "Monitor" },
      })
    end,
  },
}
