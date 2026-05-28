# Neovim Keymap Cheatsheet

`<leader>` is `<Space>`. Inside nvim, hit `<leader>?` to show all maps for the
current buffer, or `<leader>sk` for a fuzzy keymap search.

> Only **custom** keymaps added in `lua/plugins/*` are listed. LazyVim defaults
> (`<leader>ff`, `<leader>sg`, `gd`, `gr`, `K`, etc.) still apply on top.

---

## Insert mode
| Keys | Action |
|------|--------|
| `jj` | Exit insert mode |

## Motion (treesitter-aware, snake_case/camelCase-aware)
| Keys | Action |
|------|--------|
| `w` / `e` / `b` | Spider motion — stops inside `snake_case`, `camelCase`, `PascalCase` |
| `]f` / `[f` | Next / previous function start |
| `]F` / `[F` | Next / previous function end |
| `]c` / `[c` | Next / previous class start |
| `]C` / `[C` | Next / previous class end |
| `]a` / `[a` | Next / previous parameter |
| `]t` / `[t` | Next / previous TODO comment |

## Text objects (visual + operator-pending)
| Object | Selects |
|--------|---------|
| `af` / `if` | around / inside function |
| `ac` / `ic` | around / inside class |
| `aa` / `ia` | around / inside parameter (arg) |
| `al` / `il` | around / inside loop |
| `ai` / `ii` | around / inside conditional |
| `a/`        | around comment |

## Folds (nvim-ufo)
| Keys | Action |
|------|--------|
| `zR` | Open **all** folds |
| `zM` | Close **all** folds |
| `zK` | Peek folded lines (or LSP hover) |

## Multi-cursor (visual-multi)
| Keys | Action |
|------|--------|
| `<C-n>` | Add next match to cursors (n/x mode) |
| `<C-Up>` / `<C-Down>` | Add cursor above / below |

---

## `<leader>` groups

### `<leader>a` — AI / Claude
| Keys | Action |
|------|--------|
| `<leader>ac` | Toggle Claude Code split |
| `<leader>af` | Focus Claude window |
| `<leader>ar` | Resume previous session |
| `<leader>aC` | Continue previous session |
| `<leader>am` | Select Claude model |
| `<leader>ab` | Add current buffer to Claude context |
| `<leader>as` | (visual) Send selection to Claude |
| `<leader>aa` | Accept Claude's proposed diff |
| `<leader>ad` | Reject Claude's proposed diff |

### `<leader>c` — Code
| Keys | Action |
|------|--------|
| `<leader>cj` | Treesj **join** to one line |
| `<leader>cJ` | Treesj **split** across lines |
| `<leader>ct` | Treesj toggle split/join |
| `<leader>cn` | Generate annotation (neogen docstring/JSDoc) |
| `<leader>cna` / `<leader>cpa` | Swap parameter with next / previous |
| `<leader>cP` | Markdown: toggle browser preview |
| `<leader>cJ` *(json/yaml)* | JSON tree picker (nvim-jqx) |
| `<leader>cq` *(json/yaml)* | jq query (nvim-jqx) |
| `<leader>cup` *(plantuml)* | PlantUML: open preview |
| `<leader>cuc` *(plantuml)* | PlantUML: save as PNG |

### `<leader>D` — Database (vim-dadbod)
| Keys | Action |
|------|--------|
| `<leader>Du` | Toggle DB UI |
| `<leader>Da` | Add connection |
| `<leader>Df` | Find buffer |
| `<leader>Dr` | Rename buffer |
| `<leader>Dq` | Last query info |

### `<leader>f` — File / find
| Keys | Action |
|------|--------|
| `-`          | Open parent directory in **oil** |
| `<leader>fo` | Floating oil filesystem buffer |

### `<leader>g` — Git
| Keys | Action |
|------|--------|
| `<leader>gd` | Diffview vs index |
| `<leader>gD` | Diffview vs HEAD~1 |
| `<leader>gH` | Repo file history |
| `<leader>gF` | Current file history |
| `<leader>gq` | Close Diffview |
| `<leader>gy` | Copy git permalink (line/range) |
| `<leader>gO` | Open repo in browser |

### `<leader>s` — Search
| Keys | Action |
|------|--------|
| `<leader>sR` | grug-far: project find/replace |
| `<leader>sr` | grug-far: scoped to current file's extension |
| `<leader>sw` | grug-far: search current word |
| `<leader>st` | Telescope: search TODO comments |
| `<leader>sT` | Telescope: search TODO / FIX only |

### `<leader>u` — UI / toggle
| Keys | Action |
|------|--------|
| `<leader>uz` | Zen mode |
| `<leader>uZ` | Twilight (dim non-scope) |
| `<leader>uh` | Toggle inlay hints *(LazyVim default)* |

### `<leader>x` — Diagnostics / quickfix
| Keys | Action |
|------|--------|
| `<leader>xq` | Toggle quickfix (quicker.nvim) |
| `<leader>xl` | Toggle loclist (quicker.nvim) |
| `<leader>xt` | Open TODOs in Trouble |
| `>` / `<`    | (in qf) expand / collapse context |

### `<leader>?` — meta
| Keys | Action |
|------|--------|
| `<leader>?` | Show all keymaps for current buffer (which-key) |

---

## Discovery
- `<leader>sk` — Snacks picker: fuzzy-find every keymap (LazyVim default).
- `:WhichKey` — full which-key tree.
- `:Lazy` — plugin status + lazy-load reasons.
- `:LspInfo` / `:Mason` / `:ConformInfo` — toolchain status.

---

## Coming from VSCode

All the familiar VSCode shortcuts work. Use them as a bridge while you learn the
vim-native motions — most VSCode keys here are *aliases*, not replacements, so
nothing stops you from also using `gd`, `K`, `<leader>ff`, etc.

### Files & navigation
| VSCode | nvim binding | Action |
|--------|--------------|--------|
| `Ctrl+S` | save | Save the file (works in normal + insert) |
| `Ctrl+P` | quick open | Fuzzy file picker (Snacks) |
| `Ctrl+Shift+P` | command palette | Command picker |
| `Ctrl+Shift+F` | find in files | Project grep |
| `Ctrl+Shift+H` | replace in files | grug-far global find/replace |
| `Ctrl+Shift+O` | go to symbol in file | LSP document symbols |
| `Ctrl+T` | go to symbol in workspace | LSP workspace symbols |
| `Ctrl+Shift+E` | focus explorer | Focus Neo-tree |
| `Ctrl+J` | toggle terminal | Snacks terminal toggle |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | switch tabs | Next / prev buffer |

### Editing
| VSCode | nvim binding | Action |
|--------|--------------|--------|
| `Ctrl+/` | toggle comment | Toggle line/selection comment |
| `Alt+↑` / `Alt+↓` | move line | Move current line / selection up/down |
| `Shift+Alt+↑` / `Shift+Alt+↓` | duplicate line | Duplicate line / selection above or below |
| `Ctrl+Shift+K` | delete line | Delete current line (no register clobber) |
| `Ctrl+Shift+Z` | redo | Redo (vim's `<C-r>` also works) |
| `Ctrl+D` | add next match | Multi-cursor: select next occurrence |
| `Ctrl+C` / `Ctrl+V` | copy/paste | System clipboard (we set `clipboard=unnamedplus`) |

### Language & code intelligence
| VSCode | nvim binding | Action |
|--------|--------------|--------|
| `F2` | rename symbol | Inline rename with live preview (`inc-rename`) |
| `F12` | go to definition | LSP jump |
| `Shift+F12` | find all references | LSP references in picker |
| `Ctrl+.` | quick fix | LSP code actions |
| `Ctrl+Space` | trigger completion | Force blink.cmp popup |
| `F8` / `Shift+F8` | next/prev problem | Diagnostic jump |
| `F5` / `F9` / `F10` / `F11` | start / breakpoint / step over / step into | DAP (LazyVim defaults) |

### What we *didn't* remap (and why)
`<C-w>`, `<C-d>`, `<C-b>`, `<C-f>`, `<C-h>` keep their vim meanings (window
prefix, half/full page motion, backspace). Once you've learned them, they're
faster than VSCode's arrow keys for navigation. **Exception:** we did override
`<C-d>` for VSCode's multi-cursor habit because it's used very frequently.
If you want it back as half-page-down, delete the `<C-d>` lines from
`lua/plugins/vscode-keymaps.lua`.

### Useful vim-native motions worth learning early
| Keys | What it does | VSCode equivalent |
|------|--------------|-------------------|
| `gd` | go to definition | F12 |
| `gr` | go to references | Shift+F12 |
| `K`  | hover docs       | hover tooltip |
| `ciw` | change inner word | double-click + type |
| `dap` | delete around paragraph | (no quick equivalent) |
| `gcc` | toggle comment line | Ctrl+/ |
| `>>` / `<<` | indent / outdent line | Tab / Shift+Tab |
| `*` | search word under cursor | (no equivalent) |
| `Ctrl+o` / `Ctrl+i` | jump back / forward | Alt+← / Alt+→ |
