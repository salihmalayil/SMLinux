# SMLinux

SMLinux is an experimental Ubuntu-based Linux desktop project. The goal is a clean graphite/navy desktop experience with a custom Qt 6/QML shell and a lightweight session.

> **Development status:** early prototype. The 0.1 ISO was assembled and structurally inspected, but a full installation and real-hardware/virtual-machine boot test has not yet been completed. This is not production-ready.

## Project layout

- `desktop/shell/` — original Qt 6/QML desktop-shell source.
- `branding/` — original SMLinux wallpaper artwork.
- `profile/` — package selection and SDDM configuration overlay.
- `releases/` — release notes and planned milestones.

## Current prototype: 0.1

The current shell prototype includes a full-screen desktop overview, app search, launcher tiles, a bottom dock, a basic Control Center panel, and launch hooks for common Ubuntu desktop applications. Launchers depend on their target applications being installed; some items remain placeholders.

## Build the desktop shell

Requirements: CMake 3.21+, Ninja, a C++ compiler, Qt 6.8+ with Qt Quick and the required QML modules.

```sh
cmake -S desktop/shell -B build -G Ninja
cmake --build build
```

Run the resulting `smlinux-shell` binary from a graphical session with the required Qt runtime modules installed.

## Full ISO build

This repository contains desktop-shell source and selected system configuration, not a complete reproducible ISO build script. The upstream Ubuntu image and generated root filesystem are intentionally excluded because they are large third-party/generated artifacts with separate licensing and redistribution considerations.

## Release plan

- **0.1 — Prototype:** initial Ubuntu-based image and first custom desktop-shell implementation.
- **1.0 — Planned stable milestone:** reproducible build, tested live session and installer, verified integrations, documentation, and release checks.
- **2.0 — Planned major milestone:** broader desktop integration, refined system tools, update/recovery workflows, and expanded hardware testing.

See `releases/` for milestone notes.

## Contributing

Issues and pull requests are welcome. Please describe the environment you tested on and include clear reproduction steps for bugs.

## Licensing and third-party components

A project-wide open-source license has not yet been selected. Until a license is added, do not assume permission to reuse or redistribute original SMLinux code. Ubuntu, Qt, and bundled packages retain their own licenses and trademarks.
