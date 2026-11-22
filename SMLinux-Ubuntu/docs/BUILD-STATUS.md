# SMLinux Ubuntu — build status

**Version:** 0.1 prototype  
**Base:** Ubuntu 26.04.1 Desktop  
**Status:** experimental; not production-ready

## Implemented in the current source tree

- Qt 6 / QML desktop shell that sits under app windows (Openbox + tint2 taskbar session).
- Live clock and real online/offline indicator.
- Search across all installed applications (.desktop files, incl. Flatpak and Snap).
- Launcher tiles and dock that hide apps that aren't installed.
- Control Center opening the real Network, Sound, Display and Power settings.
- Installer tile that finds whichever Ubuntu installer exists.
- SMLinux wallpaper artwork.
- Initial package selection and SDDM configuration overlay.

## ISO status

A custom ISO was assembled from the Ubuntu base and passed structural inspection of the ISO layout and boot metadata. This is not equivalent to a successful boot test.

**Not yet verified:** complete live boot, installation, post-install first boot, hardware compatibility, upgrade path, and all launcher integrations.

## Known limitations

- The ISO build script (scripts/build-iso.sh) is experimental and hasn't been run end to end.
- Some desktop tiles rely on external applications and may not work in every environment.
- The shell is not a full desktop shell: window switching uses the tint2 taskbar.
- Installer and recovery launchers depend on target packages and commands being available.
- A real VM or physical-machine boot test remains outstanding.

## Release gate for 1.0

1. Add and document a reproducible build pipeline.
2. Test live boot in UEFI and BIOS where supported.
3. Test installation and first boot in a clean VM.
4. Verify every launcher and remove or label placeholders.
5. Document hardware requirements, known issues, checksums, and recovery steps.
6. Review third-party licensing (original SMLinux code is now MIT licensed).
