# eurobertics/dotfiles

Neovim setup für PHP/Symfony Entwicklung auf Basis von lazy.nvim.  
Optimiert für Terminal-First Workflows mit DevContainer Support.

## Stack

| Plugin | Funktion |
|---|---|
| lazy.nvim | Plugin Manager |
| tokyonight.nvim | Colorscheme (Moon) |
| nvim-treesitter | Syntax Highlighting |
| telescope.nvim | Fuzzy Finder |
| neo-tree.nvim | Dateibaum |
| lualine.nvim | Statusleiste |
| bufferline.nvim | Buffer Übersicht |
| mason.nvim + nvim-lspconfig | Sprachserver Management |
| nvim-cmp + LuaSnip | Autocompletion |
| gitsigns.nvim + vim-fugitive | Git Integration |
| nvim-dap + nvim-dap-ui | Debugger (Xdebug/PHP) |

**LSP:** intelephense (PHP), lua_ls (Lua)  
**DAP:** php-debug-adapter (Xdebug, Port 9003)

## Installation

```bash
git clone https://github.com/eurobertics/dotfiles ~/.dotfiles
~/.dotfiles/install.sh
```

Beim ersten Start lädt lazy.nvim alle Plugins automatisch herunter.

## DevContainer

Für DevContainer Projekte in der `devcontainer.json`:

```json
"postCreateCommand": "[ ! -d ~/.dotfiles ] && git clone https://github.com/eurobertics/dotfiles ~/.dotfiles; ~/.dotfiles/install.sh"
```

Das Dockerfile des Containers sollte Neovim 0.11+, ripgrep, nodejs und npm enthalten.

## Dotfiles updaten

Nach Änderungen an der Config einfach committen, bzw. PR starten:

```bash
cd ~/.dotfiles
git add .
git commit -m "Update nvim config"
git push
```

Die `lazy-lock.json` wird bewusst versioniert für reproduzierbare Plugin-Versionen.

## Cheat Sheet

Ein vollständiges Cheat Sheet mit allen Shortcuts und Plugin-Keymaps liegt unter `docs/neovim-cheatsheet.md`.

## Contributing

PRs sind willkommen! Bitte keine direkten Commits auf main.  
Änderungen gerne als Pull Request einreichen.

Fokus des Setups: PHP/Symfony Entwicklung, Terminal-First, DevContainer (CLI) Workflow.  
Vorschläge die diesen Fokus erweitern oder verbessern sind besonders willkommen.
