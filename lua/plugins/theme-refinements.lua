-- Theme refinement layer.
--
-- Two parts:
--   1. Tokyonight `on_highlights` — palette-aware refinement using the
--      current omarchy tokyonight colors. Keeps floats translucent (the
--      transparency.lua after-plugin handles bg stripping) but tints
--      borders, titles, selection, and inlay hints with theme accents.
--   2. A ColorScheme autocmd applying *theme-agnostic* touch-ups by
--      reading whatever the active palette is via nvim_get_hl. This way
--      the polish survives omarchy theme hot-swaps (tokyonight → catppuccin
--      → dracula etc.).

-- ── Theme-agnostic refinement applied on every ColorScheme ──
local function apply_universal_refinements()
  local function fg(name, fallback)
    local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and h.fg then return string.format("#%06x", h.fg) end
    return fallback
  end
  local function set(group, val) vim.api.nvim_set_hl(0, group, val) end

  -- Pull accents from the current theme (with tokyonight-night fallbacks)
  local accent      = fg("Function",   "#7aa2f7") -- primary accent (blue-ish)
  local accent_alt  = fg("Keyword",    "#bb9af7") -- secondary accent (purple-ish)
  local warn        = fg("DiagnosticWarn",  "#e0af68")
  local err         = fg("DiagnosticError", "#f7768e")
  local hint        = fg("DiagnosticHint",  "#1abc9c")
  local info        = fg("DiagnosticInfo",  "#0db9d7")
  local dim         = fg("Comment",    "#6d7591")

  -- Float chrome: transparent bg (transparency.lua), strong accent border + title
  set("FloatBorder",   { fg = accent_alt })
  set("FloatTitle",    { fg = accent_alt, bold = true })
  set("FloatFooter",   { fg = dim })
  set("NormalFloat",   { bg = "NONE" })

  -- Diagnostic virtual text: bg-less, soft accent fg, italic
  set("DiagnosticVirtualTextError", { fg = err,  bg = "NONE", italic = true })
  set("DiagnosticVirtualTextWarn",  { fg = warn, bg = "NONE", italic = true })
  set("DiagnosticVirtualTextInfo",  { fg = info, bg = "NONE", italic = true })
  set("DiagnosticVirtualTextHint",  { fg = hint, bg = "NONE", italic = true })
  set("DiagnosticUnderlineError",   { sp = err,  undercurl = true })
  set("DiagnosticUnderlineWarn",    { sp = warn, undercurl = true })

  -- Inlay hints: dim italic so they recede until you focus on them
  set("LspInlayHint", { fg = dim, italic = true, bg = "NONE" })

  -- Cursor line: dim gutter, accent number, no row tint
  set("CursorLine",   { bg = "NONE" })
  set("CursorLineNr", { fg = accent_alt, bold = true })
  set("LineNr",       { fg = dim })
  set("LineNrAbove",  { fg = dim })
  set("LineNrBelow",  { fg = dim })

  -- Splits: hair-line separators
  set("WinSeparator", { fg = dim })
  set("VertSplit",    { fg = dim })

  -- Search / matches
  set("MatchParen",   { fg = accent_alt, bold = true, underline = true })
  set("CurSearch",    { fg = "#14161f", bg = accent_alt, bold = true })
  set("IncSearch",    { fg = "#14161f", bg = warn, bold = true })

  -- Folds: dim italic with the accent suffix from ui.lua
  set("Folded",       { fg = dim, italic = true, bg = "NONE" })
  set("FoldColumn",   { fg = dim, bg = "NONE" })

  -- which-key
  set("WhichKey",          { fg = accent })
  set("WhichKeyGroup",     { fg = accent_alt, bold = true })
  set("WhichKeyDesc",      { fg = fg("Normal", "#cdd5e8") })
  set("WhichKeySeparator", { fg = dim })
  set("WhichKeyBorder",    { fg = accent_alt })
  set("WhichKeyTitle",     { fg = accent_alt, bold = true })

  -- Snacks picker (LazyVim's default fuzzy picker)
  set("SnacksPickerBorder",     { fg = accent_alt })
  set("SnacksPickerTitle",      { fg = accent_alt, bold = true })
  set("SnacksPickerListCursorLine", { bg = "NONE", bold = true })
  set("SnacksPickerMatch",      { fg = accent, bold = true })
  set("SnacksPickerPrompt",     { fg = accent_alt, bold = true })
  set("SnacksNotifierBorder",   { fg = accent_alt })
  set("SnacksNotifierTitle",    { fg = accent_alt, bold = true })

  -- Telescope (in case it's in play via the editor.telescope extra)
  set("TelescopeBorder",        { fg = accent_alt, bg = "NONE" })
  set("TelescopePromptBorder",  { fg = accent_alt, bg = "NONE" })
  set("TelescopePromptTitle",   { fg = "#14161f", bg = accent_alt, bold = true })
  set("TelescopeResultsTitle",  { fg = accent_alt, bold = true })
  set("TelescopeSelection",     { bg = "NONE", fg = accent_alt, bold = true })

  -- Treesitter context (the sticky header at top)
  set("TreesitterContext",            { bg = "NONE", italic = true })
  set("TreesitterContextLineNumber",  { fg = accent_alt, bold = true })
  set("TreesitterContextBottom",      { underline = true, sp = dim })

  -- Indent guides: barely-there lines, accent scope
  set("IblIndent",  { fg = "#2a2f3d" })
  set("IblWhitespace", { fg = "#2a2f3d" })
  set("IblScope",   { fg = accent_alt })
  set("MiniIndentscopeSymbol", { fg = accent_alt })

  -- Bufferline: theme indicator + soft inactive tabs
  set("BufferLineIndicatorSelected", { fg = accent_alt })
  set("BufferLineBufferSelected",    { fg = accent_alt, bold = true, italic = false })
  set("BufferLineFill",              { bg = "NONE" })
  set("BufferLineBackground",        { fg = dim, bg = "NONE" })

  -- Statusline: thin top border feel
  set("StatusLine",   { bg = "NONE" })
  set("StatusLineNC", { bg = "NONE", fg = dim })

  -- Neo-Tree: accent the cursor row + dim chrome
  set("NeoTreeRootName",        { fg = accent_alt, bold = true })
  set("NeoTreeGitModified",     { fg = warn })
  set("NeoTreeGitUntracked",    { fg = hint, italic = true })
  set("NeoTreeIndentMarker",    { fg = dim })

  -- Gitsigns
  set("GitSignsAdd",    { fg = hint })
  set("GitSignsChange", { fg = warn })
  set("GitSignsDelete", { fg = err })

  -- Render-markdown headings: graded accents
  set("RenderMarkdownH1Bg", { bg = "NONE" })
  set("RenderMarkdownH2Bg", { bg = "NONE" })
  set("RenderMarkdownH3Bg", { bg = "NONE" })
  set("RenderMarkdownH4Bg", { bg = "NONE" })
  set("RenderMarkdownH1",   { fg = accent_alt, bold = true })
  set("RenderMarkdownH2",   { fg = accent,     bold = true })
  set("RenderMarkdownH3",   { fg = warn,       bold = true })
  set("RenderMarkdownH4",   { fg = hint,       bold = true })
  set("RenderMarkdownCode", { bg = "#181b25" })

  -- Mode pill colors for lualine (subtle, matching dark theme)
  set("lualine_a_normal",   { fg = "#14161f", bg = accent_alt, bold = true })
  set("lualine_a_insert",   { fg = "#14161f", bg = hint,       bold = true })
  set("lualine_a_visual",   { fg = "#14161f", bg = warn,       bold = true })
  set("lualine_a_replace",  { fg = "#14161f", bg = err,        bold = true })
  set("lualine_a_command",  { fg = "#14161f", bg = accent,     bold = true })
end

return {
  -- 1. Tokyonight palette-aware on_highlights (merges with omarchy theme spec)
  {
    "folke/tokyonight.nvim",
    opts = function(_, opts)
      opts.on_highlights = function(hl, c)
        -- Selection: readable contrast on the dark omarchy bg (#14161f)
        hl.Visual = { bg = "#2d3149" }
        hl.VisualNOS = { bg = "#2d3149" }

        -- Pmenu (completion popup): slightly raised over the bg
        hl.Pmenu       = { bg = "#1f2230", fg = c.fg }
        hl.PmenuSel    = { bg = "#2d3149", fg = c.purple, bold = true }
        hl.PmenuThumb  = { bg = c.purple }
        hl.PmenuSbar   = { bg = "#1f2230" }

        -- Tokyo blink.cmp menu border + signature help
        hl.BlinkCmpMenuBorder       = { fg = c.purple }
        hl.BlinkCmpDocBorder        = { fg = c.purple }
        hl.BlinkCmpSignatureHelpBorder = { fg = c.purple }
        hl.BlinkCmpLabelMatch       = { fg = c.blue, bold = true }

        -- Comments slightly brighter than tokyonight default for readability
        hl.Comment = { fg = c.comment, italic = true }
        hl["@comment"] = { fg = c.comment, italic = true }

        -- @keyword/@function lean into the purple/blue accent duo
        hl["@keyword"]            = { fg = c.purple, italic = false }
        hl["@function"]           = { fg = c.blue }
        hl["@function.call"]      = { fg = c.blue }
        hl["@function.method"]    = { fg = c.blue }
      end
      return opts
    end,
  },

  -- 2. Universal refinements via ColorScheme autocmd — survives theme hot-swap
  {
    "LazyVim/LazyVim",
    init = function()
      local grp = vim.api.nvim_create_augroup("user_theme_refine", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = grp,
        callback = function()
          -- Defer so the colorscheme's own highlights settle first
          vim.schedule(apply_universal_refinements)
        end,
      })
      -- Apply once at startup in case the colorscheme is already loaded
      vim.api.nvim_create_autocmd("VimEnter", {
        group = grp,
        once = true,
        callback = function() vim.schedule(apply_universal_refinements) end,
      })
    end,
  },
}
