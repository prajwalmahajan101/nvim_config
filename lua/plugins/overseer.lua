-- Overseer async task runner. Plugin spec ships via editor.overseer extra;
-- this file adds keymaps + custom shell templates for common build/test commands.

return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerRun", "OverseerToggle", "OverseerInfo", "OverseerBuild",
      "OverseerQuickAction", "OverseerTaskAction", "OverseerSaveBundle",
      "OverseerLoadBundle", "OverseerDeleteBundle", "OverseerRunCmd",
      "OverseerClearCache",
    },
    opts = function(_, opts)
      opts.task_list = vim.tbl_deep_extend("force", opts.task_list or {}, {
        direction = "bottom",
        min_height = 14,
        max_height = 22,
        default_detail = 1,
      })
      opts.dap = false   -- DAP is wired separately; let DAP own its sessions
      opts.templates = opts.templates or { "builtin" }
      return opts
    end,
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Register a few quick templates for common stacks.
      local shell = function(name, cmd, args, condition)
        overseer.register_template({
          name = name,
          builder = function()
            return { cmd = cmd, args = args, components = { "default" } }
          end,
          condition = condition or {},
        })
      end

      shell("pytest",          "pytest", { "-v" },                 { filetype = { "python" } })
      shell("go test ./...",   "go",     { "test", "./..." },      { filetype = { "go" } })
      shell("npm test",        "npm",    { "test" },               { filetype = { "javascript", "typescript", "typescriptreact" } })
      shell("mvn test",        "mvn",    { "test" },               { filetype = { "java" } })
      shell("make",            "make",   {})
      shell("docker compose up", "docker", { "compose", "up", "-d" })
    end,
    keys = {
      { "<leader>o",  "",                          desc = "+overseer" },
      { "<leader>oo", "<cmd>OverseerToggle<cr>",   desc = "Task list" },
      { "<leader>or", "<cmd>OverseerRun<cr>",      desc = "Run template" },
      { "<leader>oR", "<cmd>OverseerRunCmd<cr>",   desc = "Run shell cmd" },
      { "<leader>oa", "<cmd>OverseerQuickAction<cr>", desc = "Quick action" },
      { "<leader>ot", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>",     desc = "Info" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>",    desc = "Build (interactive)" },
      { "<leader>os", "<cmd>OverseerSaveBundle<cr>", desc = "Save bundle" },
      { "<leader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "Load bundle" },
      { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
    },
  },
}
