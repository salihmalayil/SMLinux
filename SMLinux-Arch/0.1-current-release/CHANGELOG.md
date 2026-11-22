# Changelog

## 0.1 "Dawn" (2026-11-22)

A fresh start for SMLinux, rebuilt from the ground up on Arch Linux.

### Desktops
- **Hyprland** desktop: glass top bar, floating dock, gradient app launcher,
  rounded windows with blur, "liquid" open/close and workspace animations.
- **KDE Plasma** desktop: Breeze Dark, tangerine accent, Papirus icons.
- **One-button switching** between KDE Plasma and Hyprland (dock button, Super+K,
  or the "Switch to Hyprland" icon on the KDE desktop). Falls back automatically if
  a desktop fails to start.

### Look & feel
- New hand-drawn *Liquid Dawn* wallpaper and SMLinux logo (tangerine + mint on ink).
- **Live wallpaper**: animated aurora, pulsing sun, flowing ribbons and sparkles.
  Works as a KDE wallpaper plugin and as a Hyprland background; Super+W toggles live/still.
- Themed terminal (kitty), notifications (mako), lock screen (hyprlock) and GTK apps.

### System
- Hyprland config written in **Lua** (`~/.config/hypr/hyprland.lua`), the format Hyprland 0.57+ requires.
- Live USB logs straight into the desktop (`liveuser` / `smlinux`).
- `smlinux-install`: installs to disk with archinstall, then adds the SMLinux desktop.
- Settings hub, power menu and screenshot tool.
- PipeWire audio, NetworkManager, Bluetooth, Firefox, open-source GPU drivers.

### Known limitations
- Hyprland needs working 3D acceleration: VirtualBox may show a black screen;
  QEMU/virt-manager (Virtio GPU + 3D) or real hardware work best.
- The live wallpaper uses the GPU constantly; switch to the still wallpaper on
  slow machines.
- The installer, KDE wallpaper plugin and desktop switch have not yet been tested
  on real hardware: please report issues.
