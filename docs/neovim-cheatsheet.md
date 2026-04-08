# Neovim Cheat Sheet
> eurobertics | Tokyo Night | lazy.nvim Stack

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

## Telescope (Plugin)

| Shortcut | Aktion |
|---|---|
| `Space + ff` | Dateien suchen (Find Files) |
| `Space + fg` | Text in Projekt suchen (Live Grep) |
| `Space + fb` | Offene Buffer suchen |
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

## LSP – Sprachserver (Plugin)

| Shortcut | Aktion |
|---|---|
| `gd` | Zur Definition springen (Go to Definition) |
| `K` | Dokumentation anzeigen (Hover Docs) |
| `gr` | Alle Referenzen finden |
| `Space + rn` | Symbol umbenennen (Rename) |
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

## Git – Gitsigns + Fugitive (Plugin)

| Shortcut / Befehl | Aktion |
|---|---|
| `]c` | Nächste Änderung (Next Hunk) |
| `[c` | Vorherige Änderung (Prev Hunk) |
| `Space + hp` | Änderung als Vorschau anzeigen |
| `Space + hs` | Änderung stagen (Stage Hunk) |
| `Space + hu` | Stage rückgängig machen |
| `:Git` | Fugitive Git UI öffnen |
| `:Git commit` | Commit erstellen |
| `:Git push` | Push ausführen |

---

## Xdebug – DAP (Plugin)

| Shortcut / Befehl | Aktion |
|---|---|
| `F5` | Debug Konsole starten / Continue Step |
| `F10` | Step over |
| `F11` | Step into |
| `F12` | Step out |
| `Space + b` | Breakpoint setzen |
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

*Leader Key = `Space` | Neovim 0.11 | [github.com/eurobertics/dotfiles](https://github.com/eurobertics/dotfiles)*
