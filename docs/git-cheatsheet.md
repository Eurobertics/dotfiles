

Git cheatsheet · MD
# Git Cheat Sheet
 
> eurobertics | Standard Git CLI | kein tig/difftastic nötig
---
 
## Standard-Workflow: Add & Commit
 
| Befehl                        | Aktion                                                        |
| ------------------------------ | -------------------------------------------------------------- |
| `git status`                   | Übersicht: staged / unstaged / untracked                       |
| `git add <datei>`              | Datei komplett stagen                                           |
| `git add -p`                   | Hunk-für-Hunk stagen (interaktives Review beim Stagen)          |
| `git add -N .`                 | Untracked Dateien "vormerken", damit sie in `add -p` erscheinen |
| `git commit -m "..."`          | Commit mit Message                                              |
| `git commit -v`                | Commit-Editor zeigt Diff der staged Changes als Kommentar mit   |
| `git commit --amend`           | Letzten Commit nachträglich ändern (Inhalt und/oder Message)    |
| `git commit --amend --no-edit` | Letzten Commit ergänzen, Message bleibt unverändert             |
| `git reset <datei>`            | Datei unstagen (Änderungen bleiben erhalten)                    |
| `git reset --soft HEAD~1`      | Letzten Commit rückgängig, Änderungen bleiben staged            |
| `git restore <datei>`          | Änderungen in Datei verwerfen (zurück zu HEAD)                  |
| `git restore --staged <datei>` | Datei unstagen (Alternative zu `git reset`)                     |
 
> Tipp: `git add -N .` gefolgt von `git add -p` reviewt geänderte UND neue Dateien einheitlich, Hunk für Hunk.
---
 
## Branch Management
 
| Befehl                          | Aktion                                          |
| -------------------------------- | ------------------------------------------------ |
| `git branch`                     | Lokale Branches auflisten                        |
| `git branch -a`                  | Alle Branches auflisten (inkl. remote)           |
| `git branch <name>`              | Neuen Branch erstellen (ohne zu wechseln)        |
| `git switch <name>`              | Zu Branch wechseln                                |
| `git switch -c <name>`           | Neuen Branch erstellen und direkt wechseln        |
| `git switch -`                   | Zurück zum vorherigen Branch wechseln             |
| `git branch -d <name>`           | Branch löschen (nur wenn gemerged)                |
| `git branch -D <name>`           | Branch löschen (erzwungen, auch ungemerged)       |
| `git branch -m <alt> <neu>`      | Branch umbenennen                                 |
| `git push -u origin <name>`      | Branch erstmalig pushen und Tracking einrichten   |
| `git push origin --delete <name>`| Remote-Branch löschen                             |
| `git fetch`                      | Remote-Änderungen holen, ohne zu mergen           |
 
---
 
## Rebase, Merge & Konfliktmanagement
 
> **Merksatz:** Ich stehe auf dem Branch, der sich bewegt. Der Name im Befehl ist das Ziel, wohin ich mich bewege. Gilt für `merge` UND `rebase` gleichermaßen – der Branch im Befehl wird nie verändert.
 
| Befehl                        | Aktion                                                        |
| ------------------------------ | -------------------------------------------------------------- |
| `git merge <branch>`           | Branch in aktuellen Branch mergen (Merge-Commit)                |
| `git merge --no-ff <branch>`   | Merge erzwingen, auch wenn Fast-Forward möglich wäre            |
| `git rebase <branch>`          | Aktuellen Branch auf `<branch>` umbasieren (lineare History)    |
| `git rebase -i HEAD~<n>`       | Interaktives Rebase der letzten n Commits (squash/reorder/edit) |
| `git rebase --continue`        | Nach Konfliktlösung mit Rebase fortfahren                       |
| `git rebase --abort`           | Rebase komplett abbrechen, Ausgangszustand wiederherstellen     |
| `git rebase --skip`            | Aktuellen Commit beim Rebase überspringen                       |
| `git status`                   | Zeigt Konfliktdateien während Merge/Rebase                      |
| `git diff`                     | Zeigt Konfliktmarker (`<<<<<<<`, `=======`, `>>>>>>>`) im Detail|
| `git checkout --ours <datei>`  | Konflikt zugunsten der eigenen Version lösen                    |
| `git checkout --theirs <datei>`| Konflikt zugunsten der eingehenden Version lösen                |
| `git add <datei>`              | Konflikt als gelöst markieren (nach manueller Bearbeitung)       |
| `git merge --abort`            | Merge komplett abbrechen, Ausgangszustand wiederherstellen      |
| `git stash`                    | Änderungen beiseitelegen (z.B. vor Rebase/Pull)                 |
| `git stash pop`                | Beiseitegelegte Änderungen zurückholen                          |
 
### Was passiert wirklich? `git merge feature` vs. `git rebase feature` (auf `main` ausgecheckt)
 
**`merge`** – erzeugt einen neuen Commit, beide Historien bleiben unverändert erhalten:
```
main:     A---B---C-------M   ← neuer Merge-Commit, vereint C und E
                    \     /
feature:             D---E
```
 
**`rebase`** – schreibt die Commits des ausgecheckten Branches (main) NEU (neue Hashes!) und hängt sie hinter feature:
```
main:                    D---E---C'   ← C wird umgeschrieben zu C', hinter feature gehängt
feature:             D---E            ← bleibt unverändert
```
 
Der Unterschied ist also nicht "History kopieren vs. chronologisch einsortieren", sondern: `merge` erhält beide Historien unverändert und fügt nur einen neuen Verbindungs-Commit hinzu, während `rebase` die Commits des aktuellen Branches umschreibt. Deshalb gilt: **nie auf Branches rebasen, die andere schon gepullt haben** – die alten Commit-Hashes verschwinden faktisch.
 
> In der Praxis meist umgekehrt zum Beispiel oben: man checkt `feature` aus und macht `git rebase main` – dann werden feature's Commits neu geschrieben und vor den main-Stand gesetzt, main bleibt unberührt. Danach lässt sich oft sogar per Fast-Forward mergen.
 
> Faustregel: `merge` erhält die echte History (mit Merge-Commits), `rebase` erzeugt eine lineare, saubere History – aber nie auf Branches rebasen, die andere schon gepullt haben!
---
 
## Diffing (nur mit Git-Bordmitteln)
 
| Befehl                            | Aktion                                                 |
| ----------------------------------- | --------------------------------------------------------- |
| `git diff`                          | Unstaged Änderungen im Working Tree                        |
| `git diff --staged`                 | Staged Änderungen (was gleich committed wird)              |
| `git diff HEAD`                     | Alle Änderungen (staged + unstaged) gegen letzten Commit    |
| `git diff <branch1>..<branch2>`     | Unterschiede zwischen zwei Branches                         |
| `git diff main..HEAD`               | Eigene Commits gegenüber main (Review vor dem Push)         |
| `git diff <commit1> <commit2>`      | Unterschiede zwischen zwei Commits                          |
| `git diff -- <datei>`               | Diff nur für eine bestimmte Datei                           |
| `git diff --stat`                   | Nur Zusammenfassung (welche Dateien, wie viele Zeilen)      |
| `git log -p`                        | Commit-History inkl. Diff pro Commit                        |
| `git show <commit>`                 | Diff eines einzelnen Commits                                |
| `git diff --word-diff`              | Wortweise statt zeilenweise markieren (gut bei Prosa/Text)   |
 
> Tipp: `git diff origin/main..HEAD` zeigt genau die Commits, die noch nicht gepusht sind – der native Ersatz für `tig main..HEAD`.
---
 
## Cherry-Pick
 
| Befehl                              | Aktion                                                          |
| -------------------------------------- | -------------------------------------------------------------------- |
| `git cherry-pick <commit>`             | Einzelnen Commit von anderem Branch in aktuellen Branch übernehmen   |
| `git cherry-pick <commit1> <commit2>`  | Mehrere einzelne Commits übernehmen (in angegebener Reihenfolge)     |
| `git cherry-pick <commit1>..<commit2>` | Ganzen Commit-Bereich übernehmen (commit1 exklusiv)                  |
| `git cherry-pick -n <commit>`          | Übernehmen ohne direkt zu committen (nur staged, für Nachbearbeitung)|
| `git cherry-pick --continue`           | Nach Konfliktlösung fortfahren                                       |
| `git cherry-pick --abort`              | Cherry-Pick abbrechen, Ausgangszustand wiederherstellen               |
| `git cherry-pick --skip`               | Aktuellen Commit überspringen, mit nächstem weitermachen              |
 
> Cherry-Pick erzeugt wie Rebase einen **neuen Commit mit neuem Hash** – nützlich, um z.B. einen einzelnen Bugfix von `feature` nach `main` zu holen, ohne den ganzen Branch zu mergen.
---
 
## Tags
 
| Befehl                                   | Aktion                                            |
| ------------------------------------------- | ------------------------------------------------------ |
| `git tag`                                   | Alle Tags auflisten                                     |
| `git tag <name>`                            | Lightweight-Tag am aktuellen Commit setzen              |
| `git tag -a <name> -m "..."`                | Annotated Tag mit Message setzen (empfohlen, z.B. Releases)|
| `git tag <name> <commit>`                   | Tag an einem bestimmten, nicht dem aktuellen Commit setzen|
| `git show <tag>`                            | Details/Message eines Tags anzeigen                     |
| `git push origin <tag>`                     | Einzelnen Tag zum Remote pushen                          |
| `git push origin --tags`                    | Alle lokalen Tags zum Remote pushen                      |
| `git tag -d <name>`                         | Lokalen Tag löschen                                      |
| `git push origin --delete <name>`           | Remote-Tag löschen                                       |
| `git checkout <tag>`                        | Zustand eines Tags auschecken (detached HEAD)            |
 
> Faustregel: **annotated Tags** (`-a`) für Releases/Versionen verwenden (mit Autor, Datum, Message – wie ein eigener Commit), **lightweight Tags** nur für schnelle, private Marker.
---
 
| Befehl                                | Aktion                                                          |
| --------------------------------------- | ------------------------------------------------------------------ |
| `git log --oneline`                     | Ein Commit pro Zeile (Hash + Message), kein Diff                   |
| `git log --oneline --graph --all`       | Kompakte Branch-/Merge-Historie als ASCII-Graph                    |
| `git log --name-only`                   | Commit-Messages + Liste geänderter Dateien (ohne Diff-Inhalt)      |
| `git log --name-status`                 | Wie `--name-only`, zusätzlich Status je Datei (A/M/D = Added/Modified/Deleted) |
| `git log --stat`                        | Geänderte Dateien + Anzahl geänderter Zeilen als Mini-Balken       |
| `git log -5`                            | Nur die letzten 5 Commits anzeigen                                 |
| `git log -- <datei>`                    | Nur Commits, die diese Datei betreffen                             |
| `git log --author="Name"`               | Nur Commits eines bestimmten Autors                                |
| `git log --since="2 weeks ago"`         | Nur Commits seit einem bestimmten Zeitpunkt                        |
| `git log --grep="fix"`                  | Nur Commits, deren Message auf den Suchbegriff matcht              |
| `git shortlog -sn`                      | Commits gruppiert und gezählt pro Autor (Summary)                  |
 
> Tipp: `git log --oneline --name-status -5` ist der schnelle Überblick "was wurde in den letzten Commits wo geändert" – ohne eine einzige Diff-Zeile lesen zu müssen.
---
 
## Konfiguration
 
| Befehl                                          | Aktion                                       |
| -------------------------------------------------- | ----------------------------------------------- |
| `git config --global <key> <value>`                | Einstellung global (für alle Repos) setzen      |
| `git config <key> <value>`                         | Einstellung lokal (nur aktuelles Repo) setzen   |
| `git config --global user.name "Name"`             | Globalen Commit-Autor-Namen setzen              |
| `git config --global user.email "mail@example.com"`| Globale Commit-Autor-Email setzen               |
| `git config --list`                                | Alle aktiven Einstellungen anzeigen             |
| `git config --list --show-origin`                  | Einstellungen inkl. Herkunft (welche Datei)     |
| `git config --global --edit`                       | Globale Config-Datei direkt im Editor öffnen    |
| `git config --global --unset <key>`                | Globale Einstellung entfernen                   |
 
> Regel: Lokale Config (im Repo) überschreibt globale Config (`~/.gitconfig`) – praktisch für abweichende Email pro Projekt.
---
 
*Standard Git CLI | kein tig/difftastic | [github.com/eurobertics/dotfiles](https://github.com/eurobertics/dotfiles)*
 
