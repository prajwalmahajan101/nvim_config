-- Workaround for snacks.explorer.diagnostics crashing on stale buffer ids.
--
-- Upstream snacks/explorer/diagnostics.lua:26 calls
--   vim.api.nvim_buf_get_name(diag.bufnr)
-- without checking nvim_buf_is_valid(). When a diagnostic comes in for a
-- buffer that has just been wiped (common during picker refresh or quick
-- close/reopen cycles), nvim_buf_get_name raises "Invalid buffer id".
--
-- We monkey-patch M.update to pre-filter diagnostics whose bufnr is no
-- longer valid. Remove this file once https://github.com/folke/snacks.nvim
-- has a fix upstream.

return {
  {
    "folke/snacks.nvim",
    config = function(_, opts)
      require("snacks").setup(opts)

      local ok, diag = pcall(require, "snacks.explorer.diagnostics")
      if not ok or type(diag.update) ~= "function" then return end
      local orig = diag.update
      diag.update = function(cwd)
        local prev = vim.diagnostic.get
        vim.diagnostic.get = function(...)
          local list = prev(...)
          local out = {}
          for _, d in ipairs(list or {}) do
            if not d.bufnr or vim.api.nvim_buf_is_valid(d.bufnr) then
              table.insert(out, d)
            end
          end
          return out
        end
        local rok, rerr = pcall(orig, cwd)
        vim.diagnostic.get = prev
        if not rok then
          vim.schedule(function()
            vim.notify("snacks.explorer.diagnostics: " .. tostring(rerr), vim.log.levels.DEBUG)
          end)
        end
      end
    end,
  },
}
