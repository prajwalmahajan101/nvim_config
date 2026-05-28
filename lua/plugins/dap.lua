-- Debugger setup. nvim-dap is the framework (already pulled in transitively);
-- LazyVim's `dap.core` extra wires up nvim-dap-ui, nvim-dap-virtual-text,
-- mason-nvim-dap auto-install bridge, and keymaps (<leader>d…).
--
-- Per-language adapters install themselves automatically:
--   • Python   → debugpy        (from lang.python extra)
--   • Go       → delve          (from lang.go extra)
--   • Java     → java-debug-adapter, java-test (from lang.java extra)
--   • JS/TS    → js-debug-adapter (added by Mason below)
--   • Lua      → one-step-for-vimkind (from dap.nlua extra)

-- Note: dap.core and dap.nlua extras are declared in ../../lazyvim.json so
-- LazyVim auto-imports them in the correct spec order.

return {
  -- JS/TS debug adapter (Node + Chrome). Bridges nvim-dap to vscode-js-debug.
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
            debugger_cmd = { "js-debug-adapter" },
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
          })

          for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
            require("dap").configurations[lang] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file (" .. lang .. ")",
                program = "${file}",
                cwd = "${workspaceFolder}",
                runtimeExecutable = "node",
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach to running Node",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                request = "launch",
                name = "Launch Chrome (browser)",
                url = "http://localhost:3000",
                webRoot = "${workspaceFolder}",
              },
            }
          end
        end,
      },
    },
  },

  -- Ensure js-debug-adapter is installed by Mason
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "js-debug-adapter", -- handles both Node and Chrome (pwa-node / pwa-chrome)
      })
    end,
  },
}
