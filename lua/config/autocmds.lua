-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- ── TS/JS: organize imports on save ──────────────────────────────────────
-- Cleans unused imports + reorders them; respects the LSP server (vtsls
-- or tsserver) attached to the buffer. Skipped if no LSP supports the
-- _typescript.organizeImports command (no-op).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TsOrganizeImports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.mts", "*.cts" },
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, c in ipairs(clients) do
      if c.name == "vtsls" or c.name == "tsserver" or c.name == "typescript-language-server" then
        pcall(vim.lsp.buf.execute_command, {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(args.buf) },
        })
        return
      end
    end
  end,
})
