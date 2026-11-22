# SMLinux

SMLinux is an experimental Ubuntu-based Linux desktop project. The goal is a clean graphite/navy desktop experience with a custom Qt 6/QML shell and a lightweight session.

> **Development status:** early prototype. The 0.1 ISO was assembled and structurally inspected, but a full installation and real-hardware/virtual-machine boot test has not yet been completed. This is not production-ready.

## Project layout

- `desktop/shell/` — original Qt 6/QML desktop-shell source.
- `branding/` — original SMLinux wallpaper artwork.
- `profile/` — package selection and SDDM configuration overlay.
- `../0.1-current-release/`, `../1.0-next-big-release/`, `../2.0-future-prototype/`: release notes and planned milestones.
- `../scripts/build-iso.sh`: experimental ISO build script.

## Current prototype: 0.1

The shell is a desktop layer under your app windows (Openbox, with the tint2 taskbar for switching windows). It has a live clock, a real online/offline indicator, search across all installed apps, launcher tiles that hide when their app isn't installed, a dock, and a Control Center that opens the real Network, Sound, Display and Power settings.

## Build the desktop shell

Requirements: CMake 3.21+, Ninja, a C++ compiler, Qt 6.8+ with Qt Quick and the required QML modules.

```sh
cmake -S desktop/shell -B build -G Ninja
cmake --build build
```

Run the resulting `smlinux-shell` binary from a graphical session with the required Qt runtime modules installed.

## Full ISO build

`sudo bash scripts/build-iso.sh` (from `SMLinux-Ubuntu/`, on Ubuntu or Debian) builds the live ISO from scratch with debootstrap, compiles the shell inside the image, and removes the build tools again. **It is experimental and hasn't been run end to end yet.**

## Release plan

- **0.1 — Prototype:** initial Ubuntu-based image and first custom desktop-shell implementation.
- **1.0 — Planned stable milestone:** reproducible build, tested live session and installer, verified integrations, documentation, and release checks.
- **2.0 — Planned major milestone:** broader desktop integration, refined system tools, update/recovery workflows, and expanded hardware testing.

See the `0.1`, `1.0` and `2.0` folders in `SMLinux-Ubuntu/` for milestone notes.

## Contributing

Issues and pull requests are welcome. Please describe the environment you tested on and include clear reproduction steps for bugs.

## Licensing and third-party components

Original SMLinux code is MIT licensed (see the repository [LICENSE](../../LICENSE)). Ubuntu, Qt, and bundled packages retain their own licenses and trademarks.
