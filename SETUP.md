# Setup Guide — Adopting This Neovim Config

A complete Neovim configuration tuned for Python (FastAPI / Django), Go,
Java (Spring Boot), JS/TS, and docs (Markdown / Mermaid / PlantUML).
Built on **LazyVim**, polished for the Omarchy / Tokyonight dark aesthetic,
with **VSCode-familiar keybindings** so you can be productive on day one.

> **Day-one experience:** `Ctrl+S` saves, `Ctrl+P` opens files, `Ctrl+Shift+P`
> is the command palette, `Ctrl+/` toggles comments, `F12` goes to definition.
> See [`KEYMAPS.md`](./KEYMAPS.md) for the full cheatsheet.

---

## 1. Prerequisites

Install these once, system-wide. Without them the toolchain that Mason
auto-installs on first launch will fail.

### Required
| Tool | Purpose | Arch / Manjaro | Debian / Ubuntu | macOS |
|------|---------|----------------|-----------------|-------|
| `neovim` ≥ 0.10 | The editor itself | `pacman -S neovim` | `apt install neovim` | `brew install neovim` |
| `git` | Plugins are cloned | `pacman -S git` | `apt install git` | preinstalled |
| `ripgrep` | Project grep | `pacman -S ripgrep` | `apt install ripgrep` | `brew install ripgrep` |
| `fd` | Fast file finder | `pacman -S fd` | `apt install fd-find` | `brew install fd` |
| `node` ≥ 18 | LSPs, markdown-preview | `pacman -S nodejs npm` | `apt install nodejs npm` | `brew install node` |
| A Nerd Font | Icons render correctly | install JetBrainsMono Nerd Font | same | same |

### Strongly recommended (for the languages this config targets)
| Tool | Used by |
|------|---------|
| `python` ≥ 3.10 + `pip` | basedpyright, ruff, debugpy |
| `go` ≥ 1.21 | gopls, delve, gofumpt |
| `java` ≥ 17 (JDK) | jdtls, Spring Boot tools, PlantUML preview |
| `graphviz` (`dot`) | PlantUML preview |
| `lazygit` | `<leader>gg` git TUI |

Verify all are on `$PATH`:

```bash
for c in nvim git rg fd node python go java dot lazygit; do
  command -v "$c" >/dev/null && echo "✓ $c" || echo "✗ $c MISSING"
done
```

---

## 2. Backup your existing nvim config

```bash
# Snapshot whatever you have (config + state + cached plugins)
mv ~/.config/nvim          ~/.config/nvim.bak.$(date +%F)
mv ~/.local/share/nvim     ~/.local/share/nvim.bak.$(date +%F)   2>/dev/null || true
mv ~/.local/state/nvim     ~/.local/state/nvim.bak.$(date +%F)   2>/dev/null || true
mv ~/.cache/nvim           ~/.cache/nvim.bak.$(date +%F)         2>/dev/null || true
```

Rolling back later = move those `.bak.*` folders back into place.

---

## 3. Install this config

Pick the workflow that matches how you got the files:

### Option A — clone from git
```bash
git clone <this-repo-url> ~/.config/nvim
```

### Option B — from this checkout
```bash
cp -r /path/to/nvim_config ~/.config/nvim
```

### Option C — symlink (lets you edit the repo directly)
```bash
ln -s /path/to/nvim_config ~/.config/nvim
```

---

## 4. First launch — what to expect

```bash
nvim
```

The first launch does a lot. Be patient (~2–5 minutes the first time):

1. **lazy.nvim bootstraps** — clones itself if missing.
2. **Plugin sync** — installs ~80 plugins from `lazy-lock.json`. Watch the
   `:Lazy` UI; press `q` to dismiss when it finishes.
3. **Treesitter parsers compile** — 33 languages. You'll see
   `[nvim-treesitter] Installed 33/33 languages` in the bottom bar.
4. **Mason installs the toolchain** — LSPs, formatters, linters, debuggers.
   Open `:Mason` to watch progress; the dashboard shows a green check per
   tool. Languages with the heaviest install:
   - **Java**: `jdtls` (~150 MB) + `vscode-spring-boot-tools` (~50 MB)
   - **TypeScript**: `typescript-language-server` + `prettier` + `eslint-lsp`
   - **Python**: `basedpyright` + `ruff` + `debugpy`

If something didn't install, run `:Mason` → press `i` over the missing tool.

5. **Health check**: run `:checkhealth` once everything settles. Expected
   warnings: clipboard provider (only matters in headless), perl/ruby
   providers (we don't use them).

---

## 5. Five-minute orientation

| You want to… | Hit |
|--------------|-----|
| Open a file | `Ctrl+P` or `<leader>ff` (`<leader>` is `Space`) |
| Grep the project | `Ctrl+Shift+F` or `<leader>sg` |
| Toggle the sidebar | `<leader>e` or `Ctrl+Shift+E` |
| See **every** keymap | `<leader>?` (buffer) / `<leader>sk` (all) |
| Open the cheatsheet | `:e KEYMAPS.md` (after `cd ~/.config/nvim`) |
| Talk to Claude inside nvim | `<leader>ac` (toggle), `<leader>as` (send selection) |
| Live markdown preview | `<leader>cP` in any `.md` file |
| Open `.http` REST file | just edit `something.http`; `<leader>R` runs requests |
| Browse a DB | `<leader>Du` (uses vim-dadbod) |

For the *full* keymap inventory and the **Coming from VSCode** mapping
table, open [`KEYMAPS.md`](./KEYMAPS.md).

---

## 6. Where things live

```
~/.config/nvim/
├── init.lua                      # boots lazy.nvim
├── lazy-lock.json                # pinned plugin versions (committed)
├── lazyvim.json                  # enabled LazyVim "extras"
├── KEYMAPS.md                    # cheatsheet (THIS IS WORTH READING)
├── SETUP.md                      # you are here
├── lua/
│   ├── config/
│   │   ├── lazy.lua              # lazy.nvim bootstrap
│   │   ├── options.lua           # vim options (VSCode-feel defaults)
│   │   ├── keymaps.lua           # tiny — most maps live in plugins/
│   │   └── autocmds.lua
│   └── plugins/                  # one file per concern
│       ├── ai.lua                # Claude Code integration
│       ├── all-themes.lua        # color schemes (Omarchy hot-reload)
│       ├── completion.lua        # blink.cmp + neogen
│       ├── dap.lua               # debugger (Python/Go/Java/JS)
│       ├── diagrams.lua          # PlantUML + Mermaid
│       ├── editor.lua            # todo / zen / md-preview / jqx / oil / spider
│       ├── folding.lua           # nvim-ufo (LSP-driven folds)
│       ├── git.lua               # diffview + gitlinker
│       ├── ide.lua               # quicker.nvim, render-markdown, trouble
│       ├── langs.lua             # treesitter + Mason tool list (single source of truth)
│       ├── lsp-settings.lua      # gopls + basedpyright tuning
│       ├── refactoring-fix.lua   # patches a LazyVim crash
│       ├── search.lua            # grug-far + treesj + textobjects
│       ├── theme.lua             # active colorscheme (symlinked to Omarchy)
│       ├── theme-refinements.lua # palette-aware highlight polish
│       ├── ui.lua                # diagnostics, lualine, bufferline, Alpha
│       ├── vscode-keymaps.lua    # Ctrl+S, Ctrl+P, F12, etc.
│       ├── webdev.lua            # kulala HTTP client + dadbod DB UI
│       └── which-key.lua         # group icons + buffer keymap popup
└── plugin/
    └── after/transparency.lua    # strips bg on float groups (glassmorphism)
```

---

## 7. Customizing

**Add a plugin** — drop a file in `lua/plugins/`. lazy.nvim picks it up.
```lua
-- lua/plugins/my-plugin.lua
return {
  { "owner/repo", opts = { ... } },
}
```

**Disable a plugin** — set `enabled = false` in a spec, or delete the file.

**Change the colorscheme** — edit `lua/plugins/theme.lua` (it's symlinked to
Omarchy by default; `unlink` it first if you want to override locally).

**Toggle a LazyVim extra** — `lazyvim.json` lists them. Use the `:LazyExtras`
UI to add/remove; it writes back to that file.

**Override a keymap** — re-bind it in `lua/config/keymaps.lua` or in the
relevant `lua/plugins/*.lua` file; later definitions win.

---

## 8. Rollback

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
mv ~/.config/nvim.bak.<date>  ~/.config/nvim
mv ~/.local/share/nvim.bak.<date>  ~/.local/share/nvim  # optional
# ...etc
```

---

## 9. Troubleshooting

| Symptom | Fix |
|---------|-----|
| Icons render as `??` boxes | Install a Nerd Font (JetBrainsMono Nerd Font is good) and set your terminal to use it |
| `:Mason` says "no executable found" | Install the system prerequisite (e.g. `java` for `jdtls`, `go` for `gopls`) and re-run `:Mason` |
| LSP not attaching | `:LspInfo` to see what's running; `:Mason` to confirm the server is installed |
| Treesitter highlight broken | `:TSUpdate` then restart |
| Plugin errored on startup | `:Lazy` → press `e` on the bad spec to see the message; check `:messages` |
| Slow startup | `:Lazy profile` shows per-plugin load time (config baseline: ~60 ms) |
| Want to update plugins | `:Lazy update` (then commit the new `lazy-lock.json`) |
| Want to update toolchain | `:Mason` → `U` updates all installed tools |
| Markdown preview won't open | `:MarkdownPreview` requires `node`; first run downloads helper assets |
| PlantUML preview blank | needs `java` + `graphviz` (`dot`) on PATH |

---

## 10. Going further

- LazyVim docs: <https://www.lazyvim.org/>
- lazy.nvim docs: <https://lazy.folke.io/>
- This config's keymap cheatsheet: [`KEYMAPS.md`](./KEYMAPS.md)
- Plugin index: `:Lazy`
- Toolchain index: `:Mason`
- LSP capabilities: `:LspInfo`

Once you're comfortable, learn one new vim motion a week (`ciw`, `dap`,
`gd`, `*`, `Ctrl+o`/`Ctrl+i`). The VSCode shortcuts stay forever; the vim
motions just make you faster.
