# SMLinux roadmap

## Where each edition stands

| Edition | Status | Next step |
|---|---|---|
| **SMLinux-Arch** | **0.1.1 "Dawn" released** (pre-release): Hyprland + KDE Plasma, login screen, one-button switching, live wallpaper, installer, pacman package with updates | Real-hardware testing, then 1.0 |
| **SMLinux-Ubuntu** | 0.1 prototype: Qt/QML shell + build script (not yet run end to end) | Run the ISO build, boot it in a VM |
| **SMLinux-Debian** | Not started | Create a live-build config |

## Release model
- **0.1:** first working build of an edition.
- **1.0:** safe to recommend: tested on real hardware, graphical installer, signed releases.
- **2.0:** next-generation ideas (own shell, snapshots/rollback).

## SMLinux-Arch: next priorities
1. Test 0.1.1 on real hardware (Intel, AMD, NVIDIA) and fix what breaks.
2. Signed [smlinux] repository and ISO (GPG).
3. Graphical installer (Calamares).
4. ISO under 2 GB (single-file download).
5. Automated ISO build + QEMU boot test in CI.

Details: [SMLinux-Arch 1.0](SMLinux-Arch/1.0-next-big-release/README.md) ·
[SMLinux-Arch 2.0](SMLinux-Arch/2.0-future-prototype/README.md) ·
[SMLinux-Ubuntu 1.0](SMLinux-Ubuntu/1.0-next-big-release/README.md)
