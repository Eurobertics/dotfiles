# tmux Cheat Sheet
> eurobertics | Prefix: `Ctrl+Space`

---

## Konzepte

```
Session "projektname"
├── Window 1 "nvim"       ← wie ein Tab
│   ├── Pane links        ← Split-Bereich
│   └── Pane rechts
└── Window 2 "shell"
    └── Pane
```

- **Session** — kompletter Arbeitskontext, läuft persistent im Hintergrund
- **Window** — Tab innerhalb einer Session
- **Pane** — aufgeteilter Bereich innerhalb eines Windows

---

## Sessions

| Befehl | Aktion |
|---|---|
| `tmux new-session -s name -c /pfad` | Neue Session mit Name und Startverzeichnis |
| `tmux ls` | Alle Sessions auflisten |
| `tmux attach -t name` | Session wieder öffnen |
| `tmux kill-session -t name` | Session beenden |
| `Prefix + d` | Detach — Session läuft weiter im Hintergrund |
| `Prefix + s` | Interaktive Session-Liste mit Vorschau |
| `Prefix + $` | Aktive Session umbenennen |

---

## Windows

| Taste | Aktion |
|---|---|
| `Prefix + c` | Neues Window (im aktuellen Verzeichnis) |
| `Prefix + n` | Nächstes Window |
| `Prefix + p` | Vorheriges Window |
| `Prefix + [1-9]` | Direkt zu Window Nr. X springen |
| `Prefix + w` | Window-Liste (interaktiv) |
| `Prefix + ,` | Aktuelles Window umbenennen |
| `Prefix + &` | Aktuelles Window schließen |

---

## Panes

| Taste | Aktion |
|---|---|
| `Prefix + \|` | Vertikal splitten (links/rechts) |
| `Prefix + -` | Horizontal splitten (oben/unten) |
| `Prefix + h/j/k/l` | Zwischen Panes wechseln (Vim-Style) |
| `Prefix + x` | Aktuellen Pane schließen |
| `Prefix + z` | Pane maximieren / zurück (zoom) |
| `Prefix + Alt+Pfeiltaste` | Pane-Größe schrittweise ändern |
| `Prefix + :resize-pane -x 70%` | Exakte Breite setzen |
| `Prefix + :split-window -h -p 30` | Split mit 70/30 Aufteilung |

> Maus ist aktiviert — Trennlinie einfach ziehen für freies Resize

---

## Befehlsmodus

| Taste | Aktion |
|---|---|
| `Prefix + :` | Befehlseingabe (wie `:` in Neovim) |
| `Prefix + r` | Config neu laden (`~/.tmux.conf`) |

Beispiele im Befehlsmodus:
```
rename-window logs
rename-session embernet
split-window -h -p 30
kill-window
source-file ~/.tmux.conf
```

> Tab-Completion funktioniert im Befehlsmodus!

---

## Copy Mode (Scroll & Kopieren)

| Taste | Aktion |
|---|---|
| `Prefix + [` | Copy Mode starten (scrollen, markieren) |
| `q` | Copy Mode beenden |
| `h/j/k/l` | Navigation (Vim-Style) |
| `Ctrl+u / Ctrl+d` | Halbe Seite hoch/runter |
| `/suchbegriff` | Vorwärts suchen |
| `?suchbegriff` | Rückwärts suchen |
| `v` | Markierung starten |
| `y` | Kopieren und Copy Mode beenden |

---

## Startup Script (Beispiel)

```bash
#!/bin/bash
# embernet-dev.sh — kompletten Stack starten

tmux new-session -d -s embernet -c ~/projects/embernet-hub

tmux rename-window -t embernet:1 'hub'
tmux send-keys -t embernet:1 'nvim .' Enter

tmux new-window -t embernet -n 'core-api' -c ~/projects/embernet-core-api
tmux send-keys -t embernet:2 'docker compose up' Enter

tmux new-window -t embernet -n 'monitor'
tmux send-keys -t embernet:3 'docker stats' Enter

tmux select-window -t embernet:1
tmux attach -t embernet
```

---

## Nützliche CLI Flags

| Flag | Bedeutet | Beispiel |
|---|---|---|
| `-s` | Session name | `new-session -s mein-projekt` |
| `-n` | Window name | `new-window -n logs` |
| `-t` | Target (Session:Window.Pane) | `send-keys -t embernet:1` |
| `-d` | Detached (im Hintergrund) | `new-session -d` |
| `-c` | Startverzeichnis | `new-session -c /pfad` |
| `-h` | Horizontal split | `split-window -h` |
| `-p` | Prozent | `split-window -h -p 30` |
