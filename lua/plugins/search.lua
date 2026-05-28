-- Search / edit / motion power-ups.
--   • grug-far.nvim         — project-wide find/replace with live preview (VSCode Ctrl+Shift+H)
--   • treesj                — split/join long arg lists, JSX props, dicts in one keystroke
--   • nvim-treesitter-textobjects — af/if/ac/ic motions and text objects

return {
  -- ── Project find/replace ────────────────────────────────
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = {
      headerMaxWidth = 80,
    },
    keys = {
      { "<leader>sR", "<cmd>GrugFar<cr>",                                desc = "Search/replace (project)" },
      { "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        desc = "Search/replace (current file ext)",
      },
      { "<leader>sw",
        function() require("grug-far").open({ transient = true, prefills = { search = vim.fn.expand("<cword>") } }) end,
        desc = "Search/replace (current word)",
      },
      { "<leader>sR",
        function() require("grug-far").with_visual_selection({ transient = true }) end,
        mode = "v",
        desc = "Search/replace (visual selection)",
      },
    },
  },

  -- ── Treesj: split/join ──────────────────────────────────
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>cj", function() require("treesj").join() end,   desc = "Join lines (treesj)" },
      { "<leader>cJ", function() require("treesj").split() end,  desc = "Split lines (treesj)" },
      { "<leader>ct", function() require("treesj").toggle() end, desc = "Toggle split/join" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 200,
    },
  },

  -- ── Treesitter text-objects (main-branch API): af/if/ac/ic + jump motions ──
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)
    end,
    keys = function()
      local sel   = function(q) return function() require("nvim-treesitter-textobjects.select").select_textobject(q, "textobjects") end end
      local nxt_s = function(q) return function() require("nvim-treesitter-textobjects.move").goto_next_start(q, "textobjects") end end
      local nxt_e = function(q) return function() require("nvim-treesitter-textobjects.move").goto_next_end(q, "textobjects") end end
      local prv_s = function(q) return function() require("nvim-treesitter-textobjects.move").goto_previous_start(q, "textobjects") end end
      local prv_e = function(q) return function() require("nvim-treesitter-textobjects.move").goto_previous_end(q, "textobjects") end end
      local swp_n = function(q) return function() require("nvim-treesitter-textobjects.swap").swap_next(q) end end
      local swp_p = function(q) return function() require("nvim-treesitter-textobjects.swap").swap_previous(q) end end
      return {
        -- select (visual + operator-pending)
        { "af", sel("@function.outer"),    mode = { "x", "o" }, desc = "Select around function" },
        { "if", sel("@function.inner"),    mode = { "x", "o" }, desc = "Select inside function" },
        { "ac", sel("@class.outer"),       mode = { "x", "o" }, desc = "Select around class" },
        { "ic", sel("@class.inner"),       mode = { "x", "o" }, desc = "Select inside class" },
        { "aa", sel("@parameter.outer"),   mode = { "x", "o" }, desc = "Select around parameter" },
        { "ia", sel("@parameter.inner"),   mode = { "x", "o" }, desc = "Select inside parameter" },
        { "al", sel("@loop.outer"),        mode = { "x", "o" }, desc = "Select around loop" },
        { "il", sel("@loop.inner"),        mode = { "x", "o" }, desc = "Select inside loop" },
        { "ai", sel("@conditional.outer"), mode = { "x", "o" }, desc = "Select around conditional" },
        { "ii", sel("@conditional.inner"), mode = { "x", "o" }, desc = "Select inside conditional" },
        { "a/", sel("@comment.outer"),     mode = { "x", "o" }, desc = "Select around comment" },
        -- move
        { "]f", nxt_s("@function.outer"),  mode = { "n", "x", "o" }, desc = "Next function start" },
        { "]c", nxt_s("@class.outer"),     mode = { "n", "x", "o" }, desc = "Next class start" },
        { "]a", nxt_s("@parameter.inner"), mode = { "n", "x", "o" }, desc = "Next parameter" },
        { "]F", nxt_e("@function.outer"),  mode = { "n", "x", "o" }, desc = "Next function end" },
        { "]C", nxt_e("@class.outer"),     mode = { "n", "x", "o" }, desc = "Next class end" },
        { "[f", prv_s("@function.outer"),  mode = { "n", "x", "o" }, desc = "Prev function start" },
        { "[c", prv_s("@class.outer"),     mode = { "n", "x", "o" }, desc = "Prev class start" },
        { "[a", prv_s("@parameter.inner"), mode = { "n", "x", "o" }, desc = "Prev parameter" },
        { "[F", prv_e("@function.outer"),  mode = { "n", "x", "o" }, desc = "Prev function end" },
        { "[C", prv_e("@class.outer"),     mode = { "n", "x", "o" }, desc = "Prev class end" },
        -- swap
        { "<leader>cna", swp_n("@parameter.inner"), desc = "Swap parameter with next" },
        { "<leader>cpa", swp_p("@parameter.inner"), desc = "Swap parameter with previous" },
      }
    end,
  },
}
