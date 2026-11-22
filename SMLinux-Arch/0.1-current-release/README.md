<p align="center">
  <img src="docs/images/logo.svg" width="112" alt="smlinux logo">
</p>

<h1 align="center">SMLinux-Arch 0.1 <sub>"Dawn"</sub></h1>

<p align="center">
  <b>Two desktops. One button. A wallpaper that moves.</b><br>
  An Arch-based Linux distro with Hyprland and KDE Plasma, in tangerine and mint.
</p>

<p align="center">
  <img alt="version" src="https://img.shields.io/badge/version-0.1%20Dawn-FF7A3D">
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

- **Hyprland desktop**: glass top bar, floating dock, gradient app launcher, rounded windows
  with frosted blur and "liquid" open, close and workspace animations.
- **KDE Plasma desktop**: Breeze Dark with a tangerine accent, Papirus icons and the same wallpaper.
- **Switch with one button**: go from Hyprland to KDE and back without touching a config file.
- **Live wallpaper**: drifting aurora, a pulsing sun, flowing ribbons and twinkling sparkles.
  It's written in QML: a real KDE wallpaper plugin, and Hyprland runs the same animation.
- **Own visual identity**: a hand-drawn wallpaper and logo, plus a matching terminal,
  notifications, lock screen and GTK theme.
- **Live USB → installed system**: try it live, then install it with one click.

## 📥 Download

Get the ISO from the [**Releases**](https://github.com/salihmalayil/SMLinux/releases) page, write it to a USB stick with
[Ventoy](https://www.ventoy.net/), [Rufus](https://rufus.ie/) or
[balenaEtcher](https://etcher.balena.io/), and boot from it.

The live session logs in automatically as **`liveuser`**, password **`smlinux`**.

> **Testing in a VM?** Hyprland needs 3D acceleration. **QEMU / virt-manager** with
> *Virtio* video and *3D acceleration* works best. VirtualBox (VMSVGA, 3D on, 128 MB video
> memory, EFI) may show a black screen; that's VirtualBox's 3D support, not the ISO.

## 🔀 Switching desktops

| From | How |
|---|---|
| Hyprland → KDE | Click **KDE** in the dock · **Super+K** · Settings → *Switch to KDE Plasma* |
| KDE → Hyprland | Double-click **Switch to Hyprland** on the desktop · search "Switch Desktop" |

SMLinux asks you to confirm, saves your choice and logs you out. On the live USB you're
logged straight back in to the other desktop. If a desktop ever fails to start, SMLinux
falls back to the other one automatically.

## 🌅 Live wallpaper

- **Hyprland:** **Super+W** (or Settings → *Wallpaper*) toggles live and still. The still
  image is always drawn underneath, so you never get a blank screen.
- **KDE:** right-click the desktop → *Configure Desktop and Wallpaper* →
  *SMLinux Liquid Dawn (live)*.

## ⌨️ Keyboard shortcuts (Hyprland)

| Keys | Action | | Keys | Action |
|---|---|---|---|---|
| Super + Space | App launcher | | Super + K | Switch to KDE |
| Super + Enter | Terminal | | Super + W | Live / still wallpaper |
| Super + E | Files | | Super + L | Lock |
| Super + B | Firefox | | Super + Q | Close window |
| Super + I | Settings | | Super + F / V | Fullscreen / float |
| Super + Esc | Power menu | | Super + 1–6 | Workspaces |
| Print | Screenshot area | | Shift + Print | Screenshot screen |

## 💾 Installing to a disk

Click the gradient download icon in the dock, or run `sudo smlinux-install`. It uses
**archinstall** for the disk, user and password steps: choose the **Minimal** profile and
answer **no** to the chroot question. Then it installs the SMLinux desktops onto the new
system. After a reboot, log in and your desktop starts automatically.

## 🛠️ Building the ISO yourself

You need Arch Linux: a real install, a VM, or **Arch in WSL** on Windows.

```powershell
wsl --install archlinux
```

Then, inside Arch:

```bash
pacman-key --init && pacman-key --populate archlinux
pacman -Syu --noconfirm
git clone https://github.com/salihmalayil/SMLinux.git
cd SMLinux/SMLinux-Arch/0.1-current-release
sudo bash build.sh
```

The build downloads about 2.5 GB and takes 10–40 minutes. The ISO lands in `out/` as `smlinux-0.1-x86_64.iso`.

## 📁 Project layout

| Path | What it is |
|---|---|
| `build.sh` | Builds the ISO from Arch's official `releng` profile plus the SMLinux layer |
| `packages.smlinux` | Extra packages: Hyprland, KDE Plasma, PipeWire, NetworkManager, Firefox, fonts… |
| `airootfs/etc/skel/.config/` | Desktop configs every user gets: `hypr/`, `waybar/`, `wofi/`, `mako/`, `kitty/`, GTK |
| `airootfs/usr/share/plasma/wallpapers/org.smlinux.liquid/` | The live wallpaper (QML) |
| `airootfs/usr/share/backgrounds/smlinux/` | Still wallpaper |
| `airootfs/usr/local/bin/smlinux-*` | Installer, desktop switch, wallpaper, settings, power menu, screenshots |

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
