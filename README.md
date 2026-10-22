# COSMIC System Monitor Applet

<p align="center">
<img src="resources/popup.png" width="400" alt="Popup Settings">
</p>

Clean and powerful system monitor applet for the **COSMIC Desktop Environment**.

## What is COSMIC System Monitor?

A lightweight system monitoring applet that integrates seamlessly with COSMIC Desktop, showing real-time system metrics in the panel. Perfect for users who want to keep track of their system performance without cluttering their desktop.

## Supported Distributions

| Distribution | Status |
|--------------|--------|
| Pop!_OS 22.04+ | ok |
| Ubuntu 22.04+ | ok |
| Fedora 38+ | ok |
| Arch Linux | ok | 

> **Note**: This applet is designed specifically for COSMIC Desktop. 

## Prerequisites

### Rust Toolchain

This project uses Rust, so you'll need the Rust toolchain which includes `cargo`.

**Debian/Ubuntu:**
```bash
sudo apt update && sudo apt install rustc cargo
```

**Fedora/CentOS/RHEL:**
```bash
sudo dnf install rust cargo
```

**Arch Linux:**
```bash
sudo pacman -S rust cargo
```

### 2. Just (Command Runner)

**Debian/Ubuntu:**
```bash
sudo apt update && sudo apt install just
```

**Fedora/CentOS/RHEL:**
```bash
sudo dnf install just
```

**Arch Linux:**
```bash
sudo pacman -S just
```

### 3. System Development Libraries

**Debian/Ubuntu:**
```bash
sudo apt update && sudo apt install build-essential libsensors-dev libgtk-3-dev libdbus-1-dev pkg-config
```

**Fedora/CentOS/RHEL:**
```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install lm_sensors-devel gtk3-devel dbus-devel pkg-config
```

**Arch Linux:**
```bash
sudo pacman -S base-devel lm_sensors gtk3 dbus pkgconf
```

### 4. COSMIC Dependencies

Since this applet uses `libcosmic`, you may need additional dependencies:

**Pop!_OS:**
```bash
sudo apt update && sudo apt install libcosmic-dev
```

**Other Distributions:**
You may need to build `libcosmic` from source. Check the [libcosmic repository](https://github.com/pop-os/libcosmic) for more information.

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/marcossl10/cosmic-system-monitor.git
cd cosmic-system-monitor
```

### Step 2: Build and Install

```bash
sudo just install
```

This will:
- Build the application in release mode
- Install the binary to `/usr/bin/cosmic-sys-monitor`
- Install desktop entry to `/usr/share/applications/`
- Install app icon to `/usr/share/icons/hicolor/symbolic/apps/`
- Install metainfo to `/usr/share/metainfo/`

### Alternative: User-local install (no sudo)

If you do not want to modify system directories, install everything into your
home directory instead:

```bash
just install-user
```

This installs:
- The binary to `~/.local/bin/cosmic-sys-monitor`
- The desktop entry to `~/.local/share/applications/`
- The icon and metainfo under `~/.local/share/`

The recipe rewrites the desktop entry's `Exec=` line to the absolute path of
the user-local binary, so no `PATH` changes are required. It then restarts the
COSMIC panel so the applet picks up the new entry.

This works without `sudo` because COSMIC resolves applets from XDG desktop
entries, and entries in `~/.local/share/applications` take precedence over
entries in `/usr/share/applications`. A user-local install therefore shadows a
system-wide install without touching it.

To remove a user-local install:

```bash
just uninstall-user
```

### Step 3: Restart COSMIC Panel

Log out and log back in, or restart the COSMIC panel:

```bash
killall -9 cosmic-panel
```

The applet should now appear in your panel configuration.

## Usage

### Adding to Panel

1. Open **Settings**
2. Navigate to **Desktop** → **Panel**
3. Click the **+** button to add an applet
4. Select **System Monitor**


## Features

- 📊 **CPU Usage** - Real-time processor usage monitoring
- 💾 **Memory Usage** - RAM usage (percentage and GB)
- 🎮 **GPU Usage** - Usage, Temperature and VRAM (percentage and GB)
- 💿 **Disk Usage** - Disk space usage (percentage and GB)
- 🌡️ **Temperature** - CPU and GPU temperatures
- 🌐 **Network** - Real-time download/upload speeds (B/s, KB/s, MB/s)
- ⚙️ **Configurable** - Toggle metrics on/off via popup menu
- 🎨 **Native Look** - Seamless COSMIC Desktop integration
- ⚡ **Low Resource** - Minimal memory and CPU footprint

## Troubleshooting

### Applet Not Appearing

1. Verify installation: `ls -la /usr/bin/cosmic-sys-monitor`
2. Check logs: `journalctl -u cosmic-sys-monitor` (if running as service)
3. Try running manually: `cosmic-sys-monitor`

### Build Fails

1. Ensure all dependencies are installed
2. Update Rust: `rustup update`
3. Clean build: `just clean && cargo build --release`

### Sensors Not Detected

```bash
sudo sensors-detect
sudo systemctl enable --now lm_sensors
```

## Building from Source

### Debug Build
```bash
just build-debug
```

### Release Build
```bash
just build-release
```

### Run Without Installing
```bash
just run
```

### Check Code Quality
```bash
just check
```

### Testing a Local Build Without Installing System-wide

`cosmic-panel` resolves applet executables through XDG desktop entries. Placing
an entry with the same filename in `~/.local/share/applications` shadows the
system entry in `/usr/share/applications`, so the panel will launch your local
build instead:

```bash
just install-user
```

The panel also watches its user config at
`~/.config/cosmic/com.system76.CosmicPanel.Panel/v1/plugins_center`. Changing
that list makes the panel recreate the panel space and respawn its applets.
You can therefore reload the applet without restarting the panel or logging
out, by either:

- removing and re-adding the applet in **Settings → Desktop → Panel**, or
- briefly toggling the applet list in `plugins_center` (advanced; back up the
  file first and preserve any other applet entries).

For example, temporarily replace the contents of `plugins_center` with:

```ron
Some([])
```

then restore the original list (for example):

```ron
Some([
    "io.github.marcos.SysMonitor",
])
```

Verify which binary the panel actually launched with:

```bash
readlink /proc/$(pgrep -n cosmic-sys-monitor)/exe
```

None of this requires `sudo` or a session restart. Only a system-wide install
under `/usr` needs root.

## Uninstallation

System-wide install:

```bash
sudo just uninstall
```

User-local install:

```bash
just uninstall-user
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [pop-os/libcosmic](https://github.com/pop-os/libcosmic) - COSMIC Desktop library
- [sysinfo](https://github.com/GuillaumeGomez/sysinfo) - System information library
