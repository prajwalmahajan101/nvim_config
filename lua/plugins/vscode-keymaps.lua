-- VSCode parity layer.
--
-- Familiar Ctrl + F# shortcuts so a VSCode user can be productive on day one
-- without abandoning vim muscle memory. We deliberately do NOT remap:
--   • <C-w>  — vim window prefix (split nav, etc.)
--   • <C-d>  — half-page down (heavily used in vim)
--   • <C-b>  — page up
--   • <C-f>  — page down
--   • <C-h>  — backspace in insert / split-left in normal
-- VSCode's analogues for those (sidebar toggle, page nav, etc.) get other
-- bindings below where possible.

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

return {
  -- These bindings need to be set up after LazyVim/plugins load so the
  -- pickers/LSP utilities resolve correctly.
  {
    "LazyVim/LazyVim",
    keys = {
      -- ── File / save ──
      { "<C-s>", "<cmd>silent! update<cr>", mode = { "n", "x" }, desc = "Save file" },
      { "<C-s>", "<Esc><cmd>silent! update<cr>", mode = "i",     desc = "Save file" },

      -- ── Pickers (Ctrl+P / Ctrl+Shift+P / Ctrl+Shift+F) ──
      { "<C-p>",       function() Snacks.picker.files() end,             desc = "Quick open file" },
      { "<C-S-p>",     function() Snacks.picker.commands() end,          desc = "Command palette" },
      { "<C-S-f>",     function() Snacks.picker.grep() end,              desc = "Find in files (project grep)" },

      -- Project find/replace (Ctrl+Shift+H) — reuses grug-far from search.lua
      { "<C-S-h>",     "<cmd>GrugFar<cr>", desc = "Replace in files" },

      -- Symbols (Ctrl+Shift+O = in file, Ctrl+T = in workspace)
      { "<C-S-o>",     function() Snacks.picker.lsp_symbols() end,           desc = "Go to symbol in file" },
      { "<C-t>",       function() Snacks.picker.lsp_workspace_symbols() end, desc = "Go to symbol in workspace" },

      -- Sidebar (Ctrl+Shift+E) — focus / toggle neo-tree
      { "<C-S-e>",     "<cmd>Neotree focus<cr>",                          desc = "Focus file explorer" },

      -- Terminal (Ctrl+J like VSCode panel; <leader>` for floating variant)
      { "<C-j>",       function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },
      { "<leader>`",   function() Snacks.terminal() end,        mode = "n",         desc = "Floating terminal" },

      -- ── Comment toggle (Ctrl+/) ──
      { "<C-/>",       "gcc", mode = "n", remap = true, desc = "Toggle comment" },
      { "<C-_>",       "gcc", mode = "n", remap = true, desc = "Toggle comment" }, -- some terminals send <C-_>
      { "<C-/>",       "gc",  mode = "x", remap = true, desc = "Toggle comment" },
      { "<C-_>",       "gc",  mode = "x", remap = true, desc = "Toggle comment" },
      { "<C-/>",       "<Esc>gcca", mode = "i", remap = true, desc = "Toggle comment" },

      -- ── Line operations ──
      -- Move lines (Alt+Up/Down) — VSCode-style arrows in addition to mini.move's <A-j>/<A-k>
      { "<A-Up>",      "<cmd>m .-2<cr>==",     mode = "n", desc = "Move line up" },
      { "<A-Down>",    "<cmd>m .+1<cr>==",     mode = "n", desc = "Move line down" },
      { "<A-Up>",      "<Esc><cmd>m .-2<cr>==gi", mode = "i", desc = "Move line up" },
      { "<A-Down>",    "<Esc><cmd>m .+1<cr>==gi", mode = "i", desc = "Move line down" },
      { "<A-Up>",      ":m '<-2<cr>gv=gv",     mode = "x", desc = "Move selection up" },
      { "<A-Down>",    ":m '>+1<cr>gv=gv",     mode = "x", desc = "Move selection down" },

      -- Duplicate line (Shift+Alt+Down/Up)
      { "<S-A-Down>",  "<cmd>t .<cr>",         mode = "n", desc = "Duplicate line down" },
      { "<S-A-Up>",    "<cmd>t .-1<cr>",       mode = "n", desc = "Duplicate line up" },
      { "<S-A-Down>",  ":t '><cr>gv",          mode = "x", desc = "Duplicate selection down" },
      { "<S-A-Up>",    ":t '<-1<cr>gv",        mode = "x", desc = "Duplicate selection up" },

      -- Delete whole line (Ctrl+Shift+K)
      { "<C-S-k>",     '"_dd',                  mode = "n", desc = "Delete line" },
      { "<C-S-k>",     '<Esc>"_ddi',            mode = "i", desc = "Delete line" },

      -- Redo (Ctrl+Shift+Z) — VSCode users reach for this; vim's <C-r> still works
      { "<C-S-z>",     "<C-r>",                 mode = "n", desc = "Redo" },
      { "<C-S-z>",     "<Esc><C-r>",            mode = "i", desc = "Redo" },

      -- ── Buffer / tab nav (Ctrl+Tab / Ctrl+Shift+Tab) ──
      -- Many terminals can't distinguish <C-Tab> from <Tab>; we map both the
      -- VSCode binding and a guaranteed-working fallback.
      { "<C-Tab>",     "<cmd>bnext<cr>",        desc = "Next buffer" },
      { "<C-S-Tab>",   "<cmd>bprevious<cr>",    desc = "Previous buffer" },

      -- ── LSP (F2, F12, Shift+F12, Ctrl+.) ──
      { "<F2>",        "<cmd>IncRename <C-r><C-w><cr>", desc = "Rename symbol" },
      { "<F12>",       function() vim.lsp.buf.definition() end,                 desc = "Go to definition" },
      { "<S-F12>",     function() Snacks.picker.lsp_references() end,           desc = "Find all references" },
      { "<C-.>",       function() vim.lsp.buf.code_action() end, mode = { "n", "x" }, desc = "Quick fix / code action" },

      -- Trigger completion manually (Ctrl+Space)
      { "<C-Space>", function() require("blink.cmp").show() end, mode = "i", desc = "Trigger completion" },

      -- ── Diagnostics nav (F8 / Shift+F8) ──
      { "<F8>",        function() vim.diagnostic.jump({ count = 1, float = true })  end, desc = "Next problem" },
      { "<S-F8>",      function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = "Previous problem" },

      -- ── Multi-cursor alias (Ctrl+D = add next match) ──
      -- visual-multi already binds <C-n>; add <C-d> as the VSCode habit.
      -- WARNING: this overrides vim's half-page-down. We accept the tradeoff
      -- because VSCode users press Ctrl+D constantly. Use <C-d> sparingly in
      -- normal mode or switch to <C-n> once you've internalized vim navigation.
      { "<C-d>",       "<Plug>(VM-Find-Under)",         mode = "n", desc = "Add next occurrence (multi-cursor)" },
      { "<C-d>",       "<Plug>(VM-Find-Subword-Under)", mode = "x", desc = "Add next occurrence (multi-cursor)" },

      -- ── Zoom (Ctrl+= / Ctrl+-) — works for gui clients (neovide / VSCode-nvim) ──
      -- In terminal these are no-ops; harmless to define.
      { "<C-=>",       function()
          if vim.g.neovide then vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) * 1.1 end
        end, desc = "Zoom in (GUI)" },
      { "<C-->",       function()
          if vim.g.neovide then vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) / 1.1 end
        end, desc = "Zoom out (GUI)" },
    },
  },
}
