# Project overview

SMLinux is a Linux desktop project with its own visual identity: tangerine and mint,
glass panels, rounded corners, smooth animations and a live "Liquid Dawn" wallpaper.

## Editions
- **SMLinux-Arch:** the main edition. Arch Linux + Hyprland + KDE Plasma, released as 0.1.1.
- **SMLinux-Ubuntu:** a prototype with a custom Qt/QML desktop shell on Openbox.
- **SMLinux-Debian:** planned, not started.

## How SMLinux-Arch is put together
- `pkg/smlinux-desktop/`: a normal pacman package that owns every SMLinux file
  (configs, scripts, wallpapers, the live-wallpaper plugin, login-screen setup). Installed
  systems get SMLinux fixes through the [smlinux] repository with `pacman -Syu`.
- `airootfs/`: files only for the live USB (live user, auto-login, installer).
- `build.sh`: builds the package, then the ISO from Arch's official `releng` profile.

## Release tracks
Each edition uses the same three tracks: **0.1** (first working build), **1.0** (safe to
recommend) and **2.0** (next-generation ideas). See the [roadmap](../ROADMAP.md).

## License
Everything original in this repository is MIT licensed ([LICENSE](../LICENSE)). The
software SMLinux installs (Arch, Ubuntu, KDE, Hyprland, Qt, ...) keeps its own licenses.
