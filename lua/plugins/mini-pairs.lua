-- mini.pairs polish: less aggressive in prose / strings, disabled in pickers,
-- smarter Python f-string handling.

return {
  {
    "echasnovski/mini.pairs",
    opts = function(_, opts)
      opts = opts or {}
      opts.modes = vim.tbl_deep_extend("force", opts.modes or {}, {
        insert = true,
        command = false,
        terminal = false,
      })
      -- Filetypes where auto-pairing is more annoying than helpful.
      opts.skip_ts = opts.skip_ts or { "string" }
      opts.skip_unbalanced = true
      opts.markdown = true

      -- Disable for picker / prompt / cmdline-ish buffers.
      opts.mappings = opts.mappings or {}
      for _, key in ipairs({ "(", "[", "{", "\"", "'", "`" }) do
        opts.mappings[key] = opts.mappings[key] or {}
      end
      return opts
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MiniPairsDisable", { clear = true }),
        pattern = {
          "TelescopePrompt", "snacks_picker_list", "snacks_input",
          "noice", "cmdline", "lazy", "mason", "help",
        },
        callback = function(args)
          vim.b[args.buf].minipairs_disable = true
        end,
      })
    end,
  },
}
