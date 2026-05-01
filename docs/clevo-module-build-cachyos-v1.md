# Tuxedo Keyboard Backlight Setup
> CachyOS / Hyprland Edition

## Voraussetzungen

- CachyOS mit eigenem Kernel (clang-gebaut)
- Tuxedo/Clevo Laptop

---

## 1. Tuxedo Drivers kompilieren

Das AUR-Paket `tuxedo-keyboard` existiert nicht mehr bzw. ist unvollständig.
Direktes Kompilieren aus dem Tuxedo Gitlab:

```bash
# Abhängigkeiten
sudo pacman -S dkms gcc clang linux-headers git

# Repo klonen
git clone https://gitlab.com/tuxedocomputers/tuxedo-drivers.git
cd tuxedo-drivers

# WICHTIG: CachyOS Kernel wurde mit clang gebaut!
# Deshalb LLVM=1 verwenden, sonst Compiler-Fehler
make LLVM=1

# Module manuell installieren (make install schlägt fehl)
sudo cp src/*.ko /lib/modules/$(uname -r)/kernel/drivers/
sudo depmod -a
```

---

## 2. Module laden

```bash
# Einmalig laden
sudo modprobe tuxedo_keyboard
```

### Autoload beim Boot

Datei `/etc/modules-load.d/tuxedo.conf` anlegen:

```
tuxedo_compatibility_check
tuxedo_keyboard
clevo_acpi
clevo_wmi
tuxedo_id
```

> Reihenfolge ist wichtig – tuxedo_compatibility_check vor tuxedo_keyboard!

---

## 3. Interfaces prüfen

```bash
# Verfügbare LED Interfaces
ls /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/

# Maximale Helligkeit
cat /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/max_brightness

# Aktuelle Helligkeit
cat /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/brightness

# Farb-Index (RGB Reihenfolge)
cat /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/multi_index

# Aktuelle Farbe
cat /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/multi_intensity
```

---

## 4. udev-Regel (ohne sudo schreiben)

Damit die Skripte ohne `sudo` funktionieren:

```bash
sudo nvim /etc/udev/rules.d/99-tuxedo-keyboard.rules
```

Inhalt:
```
SUBSYSTEM=="leds", KERNEL=="rgb:kbd_backlight", RUN+="/bin/chgrp video /sys%p/brightness /sys%p/multi_intensity", RUN+="/bin/chmod g+w /sys%p/brightness /sys%p/multi_intensity"
```

User in `video` Gruppe:
```bash
sudo usermod -aG video $USER
```

Regel aktivieren:
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Neu einloggen danach.

---

## 5. Skripte

Alle Skripte nach `~/.local/bin/` und in Fish PATH eintragen.

### kblight – Helligkeit steuern

```bash
#!/bin/bash
BRIGHTNESS="/sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/brightness"
MAX=$(cat /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/max_brightness)
CURRENT=$(cat $BRIGHTNESS)

case "$1" in
    up)
        NEW=$(( CURRENT + MAX / 5 ))
        [ $NEW -gt $MAX ] && NEW=$MAX
        echo "$NEW" | tee $BRIGHTNESS > /dev/null
        ;;
    down)
        NEW=$(( CURRENT - MAX / 5 ))
        [ $NEW -lt 0 ] && NEW=0
        echo "$NEW" | tee $BRIGHTNESS > /dev/null
        ;;
    on)  echo "$MAX" | tee $BRIGHTNESS > /dev/null ;;
    off) echo "0"    | tee $BRIGHTNESS > /dev/null ;;
    *)   echo "$1"   | tee $BRIGHTNESS > /dev/null ;;
esac
```

### kbtoggle – An/Aus Toggle

```bash
#!/bin/bash
BRIGHTNESS="/sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/brightness"
CURRENT=$(cat $BRIGHTNESS)

if [ "$CURRENT" -gt "0" ]; then
    echo "0" | tee $BRIGHTNESS > /dev/null
else
    echo "255" | tee $BRIGHTNESS > /dev/null
fi
```

### kbcolor – Farbe setzen

```bash
#!/bin/bash
INTENSITY="/sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/multi_intensity"

case "$1" in
    red)    echo "255 0 0"     | tee $INTENSITY > /dev/null ;;
    green)  echo "0 255 0"     | tee $INTENSITY > /dev/null ;;
    blue)   echo "0 0 255"     | tee $INTENSITY > /dev/null ;;
    white)  echo "255 255 255" | tee $INTENSITY > /dev/null ;;
    off)    echo "0 0 0"       | tee $INTENSITY > /dev/null ;;
    *)      echo "$1"          | tee $INTENSITY > /dev/null ;;
esac
```

```bash
chmod +x ~/.local/bin/kblight
chmod +x ~/.local/bin/kbtoggle
chmod +x ~/.local/bin/kbcolor
```

---

## 6. Hyprland Keybindings

Tastencodes ermitteln mit `wev`, dann in `~/.config/hypr/hyprland.conf`:

```
bindl  = , XF86KbdLightOnOff,    exec, kbtoggle
bindel = , XF86KbdBrightnessUp,  exec, kblight up
bindel = , XF86KbdBrightnessDown, exec, kblight down
```

> `bindel` = repeat beim Halten + funktioniert bei gesperrtem Bildschirm

```bash
hyprctl reload
```

---

## 7. Fish PATH

```bash
nvim ~/.config/fish/config.fish
```

```fish
fish_add_path ~/.local/bin
```

---

## Bekannte Probleme

- **Compiler-Fehler beim make**: CachyOS Kernel ist mit clang gebaut → immer `make LLVM=1` verwenden
- **make install schlägt fehl**: Module manuell nach `/lib/modules/$(uname -r)/kernel/drivers/` kopieren
- **Nach Kernel-Update**: Tuxedo-Drivers neu kompilieren mit `make LLVM=1` im `~/src/tuxedo-drivers` Verzeichnis
- **Brightness-Tasten noch nicht vollständig**: Dimm-Funktion über Sondertasten in Arbeit

---

## Quellen

- Tuxedo Drivers Gitlab: https://gitlab.com/tuxedocomputers/tuxedo-drivers
