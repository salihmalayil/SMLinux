# SMLinux-Ubuntu

Ubuntu-based SMLinux edition. This is the active edition for the current prototype.

## Release tracks

- [0.1 — Current prototype](0.1-current-release/README.md)
- [1.0 — Planned stable milestone](1.0-next-big-release/README.md)
- [2.0 — Planned future prototype](2.0-future-prototype/README.md)

## Source and documentation

- [Desktop shell source](source/desktop/shell/)
- [Build status and limitations](docs/BUILD-STATUS.md)
- [Package selection](profile/packages.list)
- [Branding assets](branding/)

The 0.1 ISO has been assembled and structurally inspected. It has not yet completed a full VM or physical-hardware boot/install test. See the build-status document before using it.

The repository intentionally excludes the multi-gigabyte Ubuntu base ISO and generated root filesystem. A reproducible end-to-end ISO build script is still a development task.
