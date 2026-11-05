# SMLinux-Ubuntu 0.1 — Current prototype

**Status: experimental prototype; not production-ready.**

This milestone contains the first Ubuntu-based image assembly and initial Qt/QML desktop shell.

## Included

- Full-screen SMLinux desktop overview.
- App search and launcher tiles.
- Bottom dock and basic Control Center panel.
- Qt/C++ launch hooks for common Ubuntu desktop applications.
- SMLinux wallpaper and initial SDDM configuration.
- Initial package selection.

## Validation

The ISO was assembled and passed structural inspection of its layout and boot metadata. That does not prove it boots or installs successfully.

**Still unverified:** complete live boot, clean installation, first boot, hardware compatibility, upgrade path, and every launcher integration.

## Known limitations

- No reproducible end-to-end ISO build script is included yet.
- Some tiles depend on external applications and may not work in every environment.
- The Control Center is currently a visual prototype, not a complete system-settings backend.
- Installer and recovery launchers require their target packages and commands.

Do not use this prototype as a primary or production operating system.
