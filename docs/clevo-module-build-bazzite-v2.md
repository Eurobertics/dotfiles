# Clevo / Tuxedo Keyboard Modul unter Bazzite via Distrobox bauen

Dieses Dokument beschreibt, wie das Clevo/Tuxedo-Keyboard-Modul unter **Bazzite** (immutable Fedora-basiert) in einer **Distrobox** gebaut wird, ohne das Host-System mit Build-Tools vollzumüllen.

## Überblick

- Host: Bazzite (immutable, Fedora 43 Basis)
- Kernel und Header: auf dem Host installiert
- Build-Umgebung: Distrobox-Container (`fedora:43`)
- Ziel: Kernel-Module für den **aktuellen Host-Kernel** bauen und nach `/var/lib/clevo-drivers` schreiben.

---

## 1. Voraussetzungen auf dem Host

### 1.1 Aktuellen Kernel prüfen

```bash
uname -r
# Beispiel:
# 6.17.7-ba25.fc43.x86_64
```

### 1.2 Kernel-Header / -Devel auf dem Host

Bazzite liefert die Kernel-Header direkt im Base-Image mit. Prüfen ob vorhanden:

```bash
ls /usr/src/kernels/
```

Falls nicht vorhanden, auf dem Host nachinstallieren:

```bash
sudo rpm-ostree install kernel-devel-$(uname -r) kernel-headers-$(uname -r)
```

> **Hinweis:** Nach Installation ist ein Reboot nötig, damit das neue Deployment aktiv wird.

### 1.3 Austauschverzeichnis anlegen

Das Verzeichnis `/var/lib/clevo-drivers` dient als Austauschpunkt zwischen Distrobox und Host. Es bleibt zunächst leer — die fertigen `.ko` Dateien werden später dort abgelegt.

```bash
sudo mkdir -p /var/lib/clevo-drivers
```

---

## 2. Distrobox für den Modul-Build erstellen

### 2.1 Alte Box (falls vorhanden) entfernen

```bash
distrobox rm clevo-build
```

(Fehler ignorieren, wenn die Box nicht existiert.)

### 2.2 Neue Box erstellen mit Host-Mounts

```bash
distrobox create \
  --name clevo-build \
  --image fedora:43 \
  --volume /usr/src:/usr/src:ro \
  --volume /lib/modules:/lib/modules:ro \
  --volume /var/lib/clevo-drivers:/var/lib/clevo-drivers
```

- `/usr/src` → Host-Kernel-Header (read-only)
- `/lib/modules` → Host-Kernelmodule und Symlinks (read-only)
- `/var/lib/clevo-drivers` → Zielpfad für die fertigen Module

---

## 3. In die Distrobox wechseln

```bash
distrobox enter clevo-build
```

### 3.1 Kernel-Version im Container prüfen

```bash
uname -r
# muss mit dem Host-Kernel übereinstimmen, z.B.:
# 6.17.7-ba25.fc43.x86_64
```

### 3.2 Prüfen, ob Header & Module sichtbar sind

```bash
ls /usr/src/kernels
ls /lib/modules/$(uname -r)
ls /var/lib/clevo-drivers
```

---

## 4. Build-Toolchain im Container installieren

Im Container:

```bash
sudo dnf install -y \
  gcc make binutils \
  elfutils-libelf-devel elfutils-devel \
  glibc-devel git util-linux tar bzip2 xz
```

---

## 5. Treiber-Quellcode vorbereiten

> **Hinweis:** Das ursprüngliche `tuxedo-keyboard` Repository ist veraltet und nicht mehr mit Kernel 6.17+ kompatibel. Der Treiber ist jetzt Teil von `tuxedo-drivers`.

Im Container:

```bash
git clone https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers.git
cd tuxedo-drivers
```

---

## 6. Module bauen und installieren

Im Treiber-Ordner:

```bash
make
```

Anschließend die fertigen Module nach `/var/lib/clevo-drivers/` kopieren.

> **Hinweis:** Im `tuxedo-drivers` Repo liegen manche Module in Unterverzeichnissen, nicht direkt unter `src/`.

```bash
cp src/tuxedo_compatibility_check/tuxedo_compatibility_check.ko /var/lib/clevo-drivers/
cp src/tuxedo_keyboard.ko /var/lib/clevo-drivers/
cp src/clevo_acpi.ko /var/lib/clevo-drivers/
cp src/clevo_wmi.ko /var/lib/clevo-drivers/
cp src/tuxedo_io.ko /var/lib/clevo-drivers/
```

> **Reihenfolge der Module beachten — Abhängigkeiten:**
> 1. `tuxedo_compatibility_check.ko`
> 2. `tuxedo_keyboard.ko` (benötigt: `sparse-keymap`, `led-class-multicolor`, `tuxedo_compatibility_check`)
> 3. `clevo_acpi.ko`
> 4. `clevo_wmi.ko`
> 5. `tuxedo_io.ko`

---

## 7. SELinux Kontext setzen

Bazzite hat SELinux aktiv. Die `.ko` Dateien in `/var/lib/clevo-drivers/` haben standardmäßig den falschen SELinux Kontext (`var_lib_t`) und können nicht per `insmod` geladen werden.

Den korrekten Kontext dauerhaft setzen:

```bash
sudo semanage fcontext -a -t modules_object_t "/var/lib/clevo-drivers(/.*)?"
sudo restorecon -Rv /var/lib/clevo-drivers/
```

> **Warum:** `modules_object_t` ist der SELinux Typ für Kernel-Module. Ohne diesen Kontext verweigert SELinux das Laden der Module mit `Permission denied`, auch wenn der Befehl als Root ausgeführt wird. Die `semanage fcontext` Regel ist persistent und gilt auch für neu hinzugefügte `.ko` Dateien nach zukünftigen Treiber-Updates.

---

## 8. Automatisches Laden via systemd

### 8.1 Service-Datei erstellen

```bash
sudo nano /etc/systemd/system/clevo-drivers.service
```

```ini
[Unit]
Description=Clevo/Tuxedo Keyboard Driver
After=systemd-modules-load.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/modprobe sparse-keymap
ExecStart=/usr/bin/modprobe led-class-multicolor
ExecStart=/usr/bin/insmod /var/lib/clevo-drivers/tuxedo_compatibility_check.ko
ExecStart=/usr/bin/insmod /var/lib/clevo-drivers/tuxedo_keyboard.ko
ExecStart=/usr/bin/insmod /var/lib/clevo-drivers/clevo_acpi.ko
ExecStart=/usr/bin/insmod /var/lib/clevo-drivers/clevo_wmi.ko
ExecStart=/usr/bin/insmod /var/lib/clevo-drivers/tuxedo_io.ko
ExecStop=/usr/bin/rmmod tuxedo_io
ExecStop=/usr/bin/rmmod clevo_wmi
ExecStop=/usr/bin/rmmod clevo_acpi
ExecStop=/usr/bin/rmmod tuxedo_keyboard
ExecStop=/usr/bin/rmmod tuxedo_compatibility_check

[Install]
WantedBy=multi-user.target
```

> **Hinweis:** `sparse-keymap` und `led-class-multicolor` sind Kernel-Module die bereits im System vorhanden sind, aber nicht automatisch geladen werden. Sie müssen vor den Tuxedo-Modulen verfügbar sein.

> **Hinweis:** `ExecStop` entlädt die Module in umgekehrter Reihenfolge. Das ermöglicht auch `systemctl restart clevo-drivers.service` nach einem Treiber-Update ohne Reboot.

### 8.2 Service aktivieren

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now clevo-drivers.service
sudo systemctl status clevo-drivers.service
```

### 8.3 Prüfen ob Module geladen sind

```bash
lsmod | grep tuxedo
lsmod | grep clevo
```

---

## 9. Tastatur-Backlight steuern

Der Treiber registriert das Keyboard als ein einzelnes RGB-Device (eine Zone, kein per-key RGB).

### 9.1 Device prüfen

```bash
ls /sys/class/leds/
# rgb:kbd_backlight
cat /sys/class/leds/rgb:kbd_backlight/multi_index
# red green blue
```

### 9.2 Helligkeit setzen (0-255)

```bash
echo 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness
```

### 9.3 Farbe setzen (R G B, je 0-255)

```bash
# Weiß
echo 255 255 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/multi_intensity

# Rot
echo 255 0 0 | sudo tee /sys/class/leds/rgb:kbd_backlight/multi_intensity

# Blau
echo 0 0 255 | sudo tee /sys/class/leds/rgb:kbd_backlight/multi_intensity

# Aus
echo 0 | sudo tee /sys/class/leds/rgb:kbd_backlight/brightness
```

---

## 10. Treiber aktualisieren

Nach einem Kernel-Update oder neuer Treiberversion:

1. In die Distrobox wechseln: `distrobox enter clevo-build`
2. Repo aktualisieren: `cd tuxedo-drivers && git pull`
3. Neu bauen: `make`
4. Module kopieren (siehe Schritt 6)
5. Treiber neu laden: `sudo systemctl restart clevo-drivers.service`

> **Hinweis:** Der SELinux Kontext wird durch `semanage fcontext` automatisch auf neue Dateien angewendet — kein erneuter `restorecon` nötig sofern die Regel bereits gesetzt ist.

_Ende des Dokuments._
