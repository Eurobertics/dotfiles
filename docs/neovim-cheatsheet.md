# Neovim Cheat Sheet
> eurobertics | Tokyo Night / OneDark | lazy.nvim Stack

---

## Modi

| Taste | Modus | Beschreibung |
|---|---|---|
| `ESC` | Normal | Zurück zu Normal – dein Zuhause |
| `i` | Insert | Text einfügen vor Cursor |
| `a` | Insert | Text einfügen nach Cursor |
| `o` | Insert | Neue Zeile unter Cursor |
| `O` | Insert | Neue Zeile über Cursor |
| `v` | Visual | Zeichen markieren |
| `V` | Visual Line | Ganze Zeilen markieren |
| `:` | Command | Befehle eingeben |
| `:colorscheme` | Command | Zeigt das aktuelle Farbschema |
| `:colorscheme <colorscheme>` | Command | Farbschema ändern |
| `:terminal` | Terminal | Standard Terminal öffnen |
| `:terminal <shell command>` | Terminal | Befehl ausführen im Standard terminal |
| `Ctrl+\` + `Ctrl+n` | Terminal | Terminal mode verlassen ohne zu schließen |

---

## Navigation

| Taste | Aktion |
|---|---|
| `h / j / k / l` | Links / Runter / Rauf / Rechts |
| `w` | Nächstes Wort (Anfang) |
| `b` | Vorheriges Wort (Anfang) |
| `e` | Ende des aktuellen Wortes |
| `0` | Zeilenanfang |
| `$` | Zeilenende |
| `gg` | Erste Zeile der Datei |
| `G` | Letzte Zeile der Datei |
| `Ctrl+d` | Halbe Seite runter |
| `Ctrl+u` | Halbe Seite hoch |
| `[Zahl]j / [Zahl]k` | N Zeilen runter / rauf (relativ) |

---

## Zeichen-Navigation (Fortgeschritten)

| Taste | Aktion |
|---|---|
| `f{zeichen}` | Springt zum nächsten Vorkommen des Zeichens in der Zeile |
| `F{zeichen}` | Springt zum vorherigen Vorkommen des Zeichens |
| `t{zeichen}` | Springt bis vor das Zeichen |
| `T{zeichen}` | Springt bis nach das Zeichen (rückwärts) |
| `;` | Wiederholt letzten f/t Sprung vorwärts |
| `,` | Wiederholt letzten f/t Sprung rückwärts |

> Beispiel: `f(` springt direkt zur nächsten öffnenden Klammer – in PHP extrem nützlich!

---

## Undo & Redo

| Taste | Aktion |
|---|---|
| `u` | Undo – letzten Schritt rückgängig |
| `Ctrl+r` | Redo – Undo rückgängig machen |
| `U` | Ganze Zeile wiederherstellen |

> Tipp: `vim.opt.undofile = true` in der `init.lua` aktiviert persistentes Undo – die Historie bleibt auch nach dem Schließen erhalten!

---

## Vim Grammatik – `[Anzahl] + Verb + Bewegung`

| Verb | Bedeutung | Beispiel | Effekt |
|---|---|---|---|
| `d` | Delete (löschen) | `dw` | Löscht bis nächstes Wort |
| `d` | Delete (löschen) | `d$` | Löscht bis Zeilenende |
| `d` | Delete (löschen) | `dd` | Löscht ganze Zeile |
| `d` | Delete (löschen) | `3dd` | Löscht 3 Zeilen |
| `c` | Change (ändern) | `cw` | Ändert Wort (→ Insert) |
| `c` | Change (ändern) | `c$` | Ändert bis Zeilenende |
| `y` | Yank (kopieren) | `yy` | Kopiert ganze Zeile |
| `y` | Yank (kopieren) | `yw` | Kopiert Wort |
| `p` | Paste (einfügen) | `p` | Einfügen nach Cursor |
| `p` | Paste (einfügen) | `P` | Einfügen vor Cursor |

---

## Text Objekte (Fortgeschritten)

| Kombination | Effekt |
|---|---|
| `di"` | Löscht alles in Anführungszeichen |
| `ci(` | Ändert alles in Klammern (→ Insert) |
| `da{` | Löscht alles inkl. geschweifte Klammern |
| `dit` | Löscht Inhalt eines HTML/XML Tags |
| `vip` | Markiert ganzen Paragraphen |

---

## Speichern & Beenden

| Befehl | Aktion |
|---|---|
| `:w` | Speichern |
| `:x` | Speichern + Beenden (nur bei Änderungen) |
| `:wq` | Speichern + Beenden (immer) |
| `:q` | Beenden (nur ohne Änderungen) |
| `:q!` | Beenden ohne Speichern |
| `:qa` | Alle Fenster schließen |
| `:source %` | Aktuelle Datei neu laden (Config) |

---

## Splits & Fenster

| Befehl / Taste | Aktion |
|---|---|
| `:vsplit` / `:vsp` | Vertikaler Split |
| `:split` / `:sp` | Horizontaler Split |
| `:vsp datei.php` | Datei in neuem Split öffnen |
| `Ctrl+w h` | Split links |
| `Ctrl+w l` | Split rechts |
| `Ctrl+w j` | Split unten |
| `Ctrl+w k` | Split oben |
| `Ctrl+w =` | Alle Splits gleich groß |
| `Ctrl+w q` | Aktuellen Split schließen |

---

## Buffer

| Befehl / Taste | Aktion |
|---|---|
| `:e datei.php` | Datei in Buffer öffnen |
| `:bn` | Nächster Buffer |
| `:bp` | Vorheriger Buffer |
| `:bd` | Buffer schließen |
| `:ls` | Alle Buffer anzeigen |
| `Space + fb` | Buffer mit Telescope suchen |

---

## Telescope – `Space + f` (Find)

| Shortcut | Aktion |
|---|---|
| `Space + ff` | Dateien suchen (Find Files) |
| `Space + fg` | Text in Projekt suchen (Find Grep) |
| `Space + fb` | Offene Buffer suchen (Find Buffers) |
| `j / k` | Im Telescope-Fenster navigieren |
| `Enter` | Auswahl bestätigen |
| `ESC` | Telescope schließen |

---

## Neo-Tree Dateibaum (Plugin)

| Shortcut | Aktion |
|---|---|
| `Space + e` | Dateibaum ein/ausblenden |
| `Enter` | Datei öffnen |
| `a` | Neue Datei erstellen |
| `d` | Datei löschen |
| `r` | Datei umbenennen |
| `y` | Datei kopieren |
| `x` | Datei ausschneiden |
| `p` | Einfügen |

---

## LSP – `Space + l` (Language Server)

| Shortcut | Aktion |
|---|---|
| `gd` | Zur Definition springen (nativ) |
| `K` | Dokumentation anzeigen (Hover Docs) |
| `gr` | Alle Referenzen finden (nativ) |
| `Space + lr` | Symbol umbenennen (Rename) |
| `Space + ld` | Zur Definition springen |
| `Space + lf` | Alle Referenzen finden |
| `:Mason` | Mason Package Manager öffnen |
| `:LspInfo` | Aktive Sprachserver anzeigen |

---

## Autocompletion – nvim-cmp (Plugin)

| Taste | Aktion |
|---|---|
| `Ctrl+Space` | Completion manuell triggern |
| `Tab` | Nächsten Vorschlag wählen |
| `Shift+Tab` | Vorherigen Vorschlag wählen |
| `Enter` | Vorschlag bestätigen |
| `ESC` | Completion schließen |

---

## Git – `Space + g` (Git)

| Shortcut / Befehl | Aktion |
|---|---|
| `]c` | Nächste Änderung (nativ) |
| `[c` | Vorherige Änderung (nativ) |
| `Space + gn` | Git Next Hunk |
| `Space + gp` | Git Prev Hunk |
| `Space + gh` | Git Hunk Vorschau |
| `Space + gs` | Git Stage Hunk |
| `Space + gu` | Git Undo Stage |
| `:Git` | Fugitive Git UI öffnen |
| `:Git commit` | Commit erstellen |
| `:Git push` | Push ausführen |

---

## Xdebug – `Space + d` (Debug)

| Shortcut / Befehl | Aktion |
|---|---|
| `F5` / `Space + dc` | Debug starten / Continue |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `Space + db` | Breakpoint setzen |
| `Space + dx` | Debug Konsole schließen |

---

## lazy.nvim Plugin Manager

| Befehl | Aktion |
|---|---|
| `:Lazy` | Plugin Manager öffnen |
| `:Lazy update` | Alle Plugins updaten |
| `:Lazy clean` | Nicht verwendete Plugins löschen |
| `:Lazy sync` | Installieren + Updaten + Cleanen |

---

## Keymap Kategorien – Übersicht

| Präfix | Kategorie |
|---|---|
| `Space + f` | Find (Telescope) |
| `Space + g` | Git |
| `Space + l` | LSP (Language Server) |
| `Space + d` | Debug (DAP/Xdebug) |
| `Space + e` | Explorer (Neo-Tree) |

---

*Leader Key = `Space` | Neovim 0.11 | [github.com/eurobertics/dotfiles](https://github.com/eurobertics/dotfiles)*
