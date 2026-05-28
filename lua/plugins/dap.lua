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

  -- ── Virtual text: inline values for vars in scope during debug sessions ──
  -- Lazy-attached as a dep of nvim-dap (loaded by dap.core extra's <leader>d keys).
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = true,
      only_first_definition = true,
      all_references = true,
      virt_text_pos = "eol",
      all_frames = false,
      virt_lines = false,
    },
  },

  -- ── Persistent breakpoints + extra keymaps + REPL/eval widgets ──
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end, desc = "Logpoint" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                            desc = "Toggle REPL" },
      { "<leader>dR", function() require("dap").restart() end,                                                desc = "Restart session" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                          desc = "Run to cursor" },
      { "<leader>de", function() require("dap.ui.widgets").hover() end,                                       desc = "Eval under cursor",  mode = { "n", "v" } },
      { "<leader>df", function()
          local w = require("dap.ui.widgets")
          w.centered_float(w.frames)
        end, desc = "Frames (float)" },
      { "<leader>dS", function()
          local w = require("dap.ui.widgets")
          w.centered_float(w.scopes)
        end, desc = "Scopes (float)" },
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear all breakpoints" },
    },
    config = function()
      local dap = require("dap")
      local bp_dir = vim.fn.stdpath("data") .. "/dap-breakpoints"
      vim.fn.mkdir(bp_dir, "p")

      local function bp_path(buf)
        local f = vim.api.nvim_buf_get_name(buf)
        if f == "" then return nil end
        return bp_dir .. "/" .. vim.fn.sha256(f) .. ".json"
      end

      local function save_breakpoints(buf)
        local path = bp_path(buf)
        if not path then return end
        local bps = require("dap.breakpoints").get(buf)
        local items = bps[buf] or {}
        if #items == 0 then
          if vim.uv.fs_stat(path) then vim.uv.fs_unlink(path) end
          return
        end
        local out = {}
        for _, b in ipairs(items) do
          table.insert(out, {
            line = b.line,
            condition = b.condition,
            logMessage = b.logMessage,
            hitCondition = b.hitCondition,
          })
        end
        local fd = io.open(path, "w")
        if fd then
          fd:write(vim.json.encode(out))
          fd:close()
        end
      end

      local function load_breakpoints(buf)
        local path = bp_path(buf)
        if not path or not vim.uv.fs_stat(path) then return end
        local fd = io.open(path, "r")
        if not fd then return end
        local ok, data = pcall(vim.json.decode, fd:read("*a"))
        fd:close()
        if not ok or type(data) ~= "table" then return end
        for _, b in ipairs(data) do
          require("dap.breakpoints").set({
            condition = b.condition,
            log_message = b.logMessage,
            hit_condition = b.hitCondition,
          }, buf, b.line)
        end
      end

      vim.api.nvim_create_augroup("DapPersistentBreakpoints", { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = "DapPersistentBreakpoints",
        callback = function(args) pcall(load_breakpoints, args.buf) end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = "DapPersistentBreakpoints",
        callback = function(args) pcall(save_breakpoints, args.buf) end,
      })

      -- Save remaining breakpoints on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = "DapPersistentBreakpoints",
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then pcall(save_breakpoints, buf) end
          end
        end,
      })
    end,
  },
}
