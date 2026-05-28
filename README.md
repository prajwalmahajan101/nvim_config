# nvim_config

Personal Neovim configuration — LazyVim-based, tuned for:

- **Python** (FastAPI, Django) — basedpyright + ruff + djlint, inlay hints
- **Go** — gopls with staticcheck + gofumpt + parameter hints
- **Java** (Spring Boot) — jdtls + spring-boot-tools + java-debug
- **JavaScript / TypeScript** — tsserver + biome + prettier, full DAP
- **Docs** — Markdown + Mermaid + PlantUML with live browser preview

Built for the Omarchy dark aesthetic with tokyonight + glassmorphism floats
and VSCode-familiar keybindings (`Ctrl+S`, `Ctrl+P`, `F12`, `Ctrl+/`, etc.).

| Doc | Read when |
|-----|-----------|
| **[SETUP.md](./SETUP.md)** | You are installing this config on a new machine |
| **[KEYMAPS.md](./KEYMAPS.md)** | Daily reference + Coming-from-VSCode mapping |

## At a glance

- ~60 ms cold startup (`:Lazy profile` to verify on your hardware)
- ~80 plugins, all lazy-loaded
- Single-file-per-concern under `lua/plugins/` — easy to read, easy to peel apart
- `langs.lua` is the single source of truth for treesitter parsers and Mason tools
- Theme hot-reloads with Omarchy (`omarchy theme` switches Hyprland + waybar +
  nvim in one shot)

## Layout

```
init.lua               # boots lazy.nvim
lazy-lock.json         # pinned plugin versions (commit this!)
lazyvim.json           # enabled LazyVim extras
lua/
├── config/            # options, keymaps, autocmds, lazy bootstrap
└── plugins/           # one file per concern (ai, dap, langs, ui, …)
plugin/after/          # post-colorscheme overrides (transparency)
```

See `SETUP.md` § "Where things live" for the full file-by-file breakdown.

## License

LICENSE inherited from the LazyVim starter (Apache-2.0).
