<p align="center">
  <img src="docs/images/logo.svg" width="112" alt="SMLinux logo">
</p>

<h1 align="center">SMLinux-Arch 0.1.1 <sub>"Dawn"</sub></h1>

<p align="center">
  <b>Two desktops. One button. A wallpaper that moves.</b><br>
  An Arch-based Linux distro with Hyprland and KDE Plasma, in tangerine and mint.
</p>

<p align="center">
  <img alt="version" src="https://img.shields.io/badge/version-0.1.1%20Dawn-FF7A3D">
  <img alt="base" src="https://img.shields.io/badge/base-Arch%20Linux-3DDBA8">
  <img alt="desktops" src="https://img.shields.io/badge/desktops-Hyprland%20%2B%20KDE%20Plasma-5EE6D0">
  <img alt="license" src="https://img.shields.io/badge/license-MIT-FFB347">
</p>

<p align="center">
  <img src="docs/images/live-wallpaper.png" alt="The SMLinux live wallpaper, Liquid Dawn" width="820">
  <br><sub>The <i>Liquid Dawn</i> live wallpaper (a real frame of the animation)</sub>
</p>

---

## ✨ Highlights

- **Hyprland desktop**: glass top bar, floating dock with your open apps, gradient app launcher,
  rounded windows with frosted blur and "liquid" animations, volume/brightness pop-ups.
- **KDE Plasma desktop**: Breeze Dark with a tangerine accent, Papirus icons, the same wallpaper.
- **Login screen + one-button switching** between Hyprland and KDE: apps close gracefully first.
- **Live wallpaper**: drifting aurora, pulsing sun, flowing ribbons. On every monitor, pauses
  for fullscreen apps and on battery, with a settings page in KDE.
- **Updates through pacman**: all of SMLinux is the `smlinux-desktop` package, so fixes arrive
  with a normal `pacman -Syu`.
- **Ready to use**: Firefox, image viewer, PDF viewer, video player, text editor, app store
  (Flathub), printing, firewall, power modes, clipboard history.

## 📥 Download

Get the ISO from the [**Releases**](https://github.com/salihmalayil/SMLinux/releases) page,
write it to a USB stick with [Ventoy](https://www.ventoy.net/), [Rufus](https://rufus.ie/) or
[balenaEtcher](https://etcher.balena.io/), and boot from it. If the download comes in two parts
(`.001` + `.002`), the release notes show the one command that joins them.

The live session logs in automatically; if anything asks for a password, it's **`smlinux`**.
On computers with an NVIDIA graphics card the live session starts in KDE Plasma (the installer
adds the NVIDIA driver, after which Hyprland works too).

> **Testing in a VM?** Hyprland needs 3D acceleration: **QEMU / virt-manager** with *Virtio*
> video and *3D acceleration* works best. Without 3D, SMLinux falls back to KDE Plasma.

## 🔀 Switching desktops

| From | How |
|---|---|
| Hyprland → KDE | **KDE** button in the dock · **Super+K** · Settings → *Switch to KDE Plasma* |
| KDE → Hyprland | **Meta+K** · double-click **Switch Desktop** on the desktop · search "Switch Desktop" |

SMLinux asks first, then logs out *gracefully*: open apps are asked to close, so you can save
your work. On the live USB you're logged straight back in to the other desktop. On an installed
system the login screen opens with the other desktop already selected. You can also pick the
desktop on the login screen. If a desktop crashes right at start, the next login uses the other one.

## 🌅 Live wallpaper

- **Hyprland:** **Super+W** (or Settings → *Wallpaper*) toggles live and still. The still image
  is always underneath, so you never get a blank screen. It pauses during fullscreen apps and
  on battery power.
- **KDE:** right-click the desktop → *Configure Desktop and Wallpaper* →
  *SMLinux Liquid Dawn (live)*. Settings: pause, speed, battery-saver quality.

## ⌨️ Keyboard shortcuts (Hyprland)

| Keys | Action | | Keys | Action |
|---|---|---|---|---|
| Super + Space | App launcher | | Super + K | Switch to KDE |
| Super + Enter | Terminal | | Super + W | Live / still wallpaper |
| Super + E | Files | | Super + D | Hide / show dock |
| Super + B | Firefox | | Super + N | Do Not Disturb |
| Super + I | Settings | | Super + C | Clipboard history |
| Super + Esc | Power menu | | Super + Shift + C | Colour picker |
| Super + L | Lock | | Super + Q | Close window |
| Super + F / V | Fullscreen / float | | Super + 1–6 | Workspaces |
| Print | Screenshot area | | Shift + Print | Screenshot screen |
| 3-finger swipe | Change workspace | | | |

## 💾 Installing to a disk

Click the gradient download icon in the dock (or the desktop icon in KDE), or run
`sudo smlinux-install`. It uses **archinstall** for disks, encryption, users and passwords:
choose the **Minimal** profile and make your user a **superuser**. Then it:

- mounts the new system exactly as its fstab describes (btrfs subvolumes, separate `/home`,
  `/boot` and encrypted disks all work),
- refreshes the signing keys and does a **full** upgrade,
- installs the `smlinux-desktop` package and adds the [smlinux] update repository,
- installs the **NVIDIA driver** if you have an NVIDIA card,
- turns on the login screen, NetworkManager (switching off any other network manager),
  Bluetooth, power modes, printing and the firewall,
- applies your keyboard layout to the desktops.

It keeps your chosen hostname, never copies live-USB settings, and stops with a clear message
if any step fails (`sudo smlinux-install --resume` retries after you fix it).

## 🔧 Customising

Your settings live in your home folder and always win over SMLinux's defaults:

| What | Your file | SMLinux default (updated by pacman) |
|---|---|---|
| Hyprland | `~/.config/hypr/hyprland.lua` | `/usr/share/smlinux/hypr/smlinux.lua` |
| Bar + dock | `~/.config/waybar/config.jsonc` | `/usr/share/smlinux/waybar/` |
| Launcher | `~/.config/wofi/` | `/usr/share/smlinux/wofi/` |
| Notifications | `~/.config/mako/config` | `/usr/share/smlinux/mako/config` |
| Terminal | `~/.config/kitty/kitty.conf` | `/etc/xdg/kitty/kitty.conf` |

## 🛠️ Building the ISO yourself

You need Arch Linux: a real install, a VM, or **Arch in WSL** on Windows (`wsl --install archlinux`).

```bash
pacman-key --init && pacman-key --populate archlinux
git clone https://github.com/salihmalayil/SMLinux.git
cd SMLinux/SMLinux-Arch/0.1-current-release
sudo bash build.sh                                   # or, reproducible:
sudo SMLINUX_SNAPSHOT=2026/11/22 bash build.sh       # uses that day's Arch package versions
```

`out/` then contains the ISO, `SHA256SUMS`, `pkglist-<version>.txt` (every package version in
the ISO) and `repo/` (the [smlinux] pacman repository). `bash scripts/check.sh` runs the same
checks as CI (shellcheck, JSON, Hyprland config, QML).

## 📁 Project layout

| Path | What it is |
|---|---|
| `pkg/smlinux-desktop/` | The `smlinux-desktop` pacman package: `PKGBUILD` + `root/` (mirrored to `/`) |
| `airootfs/` | Live-USB-only files: live user, auto-login, installer, firewall |
| `build.sh` | Builds the package, its repo and the ISO (from Arch's `releng` profile) |
| `packages.iso` / `packages.remove` | Packages added to / removed from `releng` |
| `iso/` | Boot-menu artwork |
| `scripts/check.sh` | Automated checks (also run by GitHub Actions) |

## 🎨 Palette

| | Name | Hex |
|---|---|---|
| ![](https://img.shields.io/badge/-%20%20%20%20-FF7A3D) | Tangerine | `#FF7A3D` |
| ![](https://img.shields.io/badge/-%20%20%20%20-FFB347) | Marigold | `#FFB347` |
| ![](https://img.shields.io/badge/-%20%20%20%20-FF5E5B) | Coral | `#FF5E5B` |
| ![](https://img.shields.io/badge/-%20%20%20%20-3DDBA8) | Mint | `#3DDBA8` |
| ![](https://img.shields.io/badge/-%20%20%20%20-5EE6D0) | Aqua | `#5EE6D0` |
| ![](https://img.shields.io/badge/-%20%20%20%20-0E1420) | Ink | `#0E1420` |

## 📜 Changelog & license

See [CHANGELOG.md](CHANGELOG.md). SMLinux's own files are [MIT licensed](LICENSE); the
packages it installs keep their own licenses.
