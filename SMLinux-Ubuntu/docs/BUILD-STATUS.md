# SMLinux Ubuntu — build status

**Version:** 0.1 prototype  
**Base:** Ubuntu 26.04.1 Desktop  
**Status:** experimental; not production-ready

## Implemented in the current source tree

- Qt 6 / QML full-screen desktop shell.
- App search and launcher tiles.
- Bottom dock and basic Control Center panel.
- Qt/C++ launcher integration for common Ubuntu applications.
- SMLinux wallpaper artwork.
- Initial package selection and SDDM configuration overlay.

## ISO status

A custom ISO was assembled from the Ubuntu base and passed structural inspection of the ISO layout and boot metadata. This is not equivalent to a successful boot test.

**Not yet verified:** complete live boot, installation, post-install first boot, hardware compatibility, upgrade path, and all launcher integrations.

## Known limitations

- No reproducible end-to-end ISO build script is included yet.
- Some desktop tiles rely on external applications and may not work in every environment.
- The Control Center is a basic mock-up, not a complete settings backend.
- Installer and recovery launchers depend on target packages and commands being available.
- A real VM or physical-machine boot test remains outstanding.

## Release gate for 1.0

1. Add and document a reproducible build pipeline.
2. Test live boot in UEFI and BIOS where supported.
3. Test installation and first boot in a clean VM.
4. Verify every launcher and remove or label placeholders.
5. Document hardware requirements, known issues, checksums, and recovery steps.
6. Review third-party licensing and add an explicit license for original SMLinux code.
