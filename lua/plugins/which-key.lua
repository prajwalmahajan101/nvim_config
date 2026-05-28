-- Polished which-key v3: icons per group, modern preset, a global "show all
-- keymaps for this buffer" pop-up bound to <leader>?, and a writer for
-- ~/.config/nvim/KEYMAPS.md so you have a static cheatsheet too.

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 250,
      win = {
        border = "rounded",
        padding = { 1, 2 },
        wo = { winblend = 0 },
      },
      icons = {
        breadcrumb = "»",
        separator  = "→",
        group      = "",
        ellipsis   = "…",
        mappings   = true,
      },
      spec = {
        { "<leader>a", group = "ai/claude",   icon = { icon = "󱙺", color = "purple" } },
        { "<leader>b", group = "buffer",      icon = { icon = "󰓩", color = "blue"   } },
        { "<leader>c", group = "code",        icon = { icon = "", color = "yellow" } },
        { "<leader>cu", group = "diagrams",   icon = { icon = "󰷈", color = "cyan"   } },
        { "<leader>d", group = "debug",       icon = { icon = "", color = "red"    } },
        { "<leader>D", group = "database",    icon = { icon = "", color = "blue"   } },
        { "<leader>f", group = "file/find",   icon = { icon = "󰈞", color = "blue"   } },
        { "<leader>g", group = "git",         icon = { icon = "", color = "orange" } },
        { "<leader>h", group = "harpoon",     icon = { icon = "󰛢", color = "cyan"   } },
        { "<leader>m", group = "markdown",    icon = { icon = "", color = "blue"   } },
        { "<leader>n", group = "notice",      icon = { icon = "", color = "yellow" } },
        { "<leader>R", group = "rest/http",   icon = { icon = "󰖟", color = "green"  } },
        { "<leader>w", group = "window",      icon = { icon = "", color = "green"  } },
        { "<leader>q", group = "quit/session",icon = { icon = "", color = "red"    } },
        { "<leader>r", group = "refactor",    icon = { icon = "", color = "yellow" } },
        { "<leader>s", group = "search",      icon = { icon = "", color = "green"  } },
        { "<leader>t", group = "test",        icon = { icon = "󰙨", color = "green"  } },
        { "<leader>u", group = "ui/toggle",   icon = { icon = "", color = "yellow" } },
        { "<leader>x", group = "diagnostics", icon = { icon = "", color = "red"    } },
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps (which-key)" },
      },
    },
  },
}
