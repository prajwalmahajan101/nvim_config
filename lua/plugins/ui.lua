-- Visual polish — calibrated defaults across diagnostics, folds, lualine,
-- bufferline, indent-blankline, and the Alpha dashboard so the editor
-- matches the Omarchy dark / glassmorphism aesthetic.

return {
  -- ── Diagnostics: severity-sorted virtual text, prefix icon, rounded floats ──
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          format = function(d)
            -- truncate long messages so virtual text stays readable
            local msg = d.message:gsub("\n", " ")
            if #msg > 80 then msg = msg:sub(1, 77) .. "…" end
            return msg
          end,
        },
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰌶 ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      },
    },
  },

  -- ── Custom fold text: « 12 lines » + first-line preview ──
  {
    "kevinhwang91/nvim-ufo",
    opts = function(_, opts)
      opts.fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  󰁂 %d "):format(end_lnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virt_text) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "Folded" })
        return newVirtText
      end
      return opts
    end,
  },

  -- ── Lualine: LSP names, macro indicator, formatter spinner ──
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- LSP servers attached to current buffer
      local function lsp_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then return "" end
        local names = {}
        for _, c in ipairs(clients) do table.insert(names, c.name) end
        return "  " .. table.concat(names, ", ")
      end

      -- Macro recording indicator
      local function macro()
        local reg = vim.fn.reg_recording()
        if reg == "" then return "" end
        return "󰑊 @" .. reg
      end

      opts.options = opts.options or {}
      opts.options.globalstatus = true
      opts.options.component_separators = { left = "│", right = "│" }
      opts.options.section_separators   = { left = "", right = "" }

      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}
      table.insert(opts.sections.lualine_c, { macro, color = { fg = "#ff9e64", gui = "bold" } })

      opts.sections.lualine_x = opts.sections.lualine_x or {}
      table.insert(opts.sections.lualine_x, 1, { lsp_clients, color = { fg = "#7aa2f7" } })

      return opts
    end,
  },

  -- ── Bufferline: slanted separators, soft inactive tabs ──
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        indicator = { style = "underline" },
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " ", info = " " }
          local out = {}
          for k, v in pairs(diag) do
            if icons[k] then table.insert(out, icons[k] .. v) end
          end
          return table.concat(out, " ")
        end,
        offsets = {
          { filetype = "neo-tree", text = "  Explorer", text_align = "left", separator = true },
          { filetype = "snacks_layout_box", text = "  Explorer", text_align = "left", separator = true },
        },
      },
    },
  },

  -- ── Indent-blankline: subtle lines, brighter scope ──
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm", "snacks_dashboard",
        },
      },
    },
  },

  -- ── Alpha dashboard: custom header (Omarchy vibe) ──
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.section.header.val = {
        "                                                  ",
        "  ██████╗ ███╗   ███╗ █████╗ ██████╗  ██████╗██╗  ██╗██╗   ██╗",
        " ██╔═══██╗████╗ ████║██╔══██╗██╔══██╗██╔════╝██║  ██║╚██╗ ██╔╝",
        " ██║   ██║██╔████╔██║███████║██████╔╝██║     ███████║ ╚████╔╝ ",
        " ██║   ██║██║╚██╔╝██║██╔══██║██╔══██╗██║     ██╔══██║  ╚██╔╝  ",
        " ╚██████╔╝██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╗██║  ██║   ██║   ",
        "  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ",
        "                                                  ",
      }
      opts.section.header.opts = { position = "center", hl = "AlphaHeader" }
      -- Tint with theme's keyword color so the header tracks colorscheme changes.
      local function tint()
        local ok, kw = pcall(vim.api.nvim_get_hl, 0, { name = "Keyword", link = false })
        local fg = (ok and kw.fg) and string.format("#%06x", kw.fg) or "#bb9af7"
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = fg, bold = true })
      end
      tint()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = vim.schedule_wrap(tint) })
      return opts
    end,
  },
}
