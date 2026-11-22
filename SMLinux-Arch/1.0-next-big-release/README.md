# SMLinux-Arch 1.0: next big release

**Status: planned, not started.** The current release is [0.1.1 "Dawn"](../0.1-current-release/README.md).

1.0 is the point where SMLinux-Arch should be safe to recommend to someone who
isn't a Linux user. Concretely, it ships when all of these are true:

## Must have
- **Tested on real hardware:** at least one Intel laptop, one AMD laptop, one NVIDIA desktop,
  live boot, install and first boot, each written up in a test report.
- **Graphical installer:** replace the archinstall terminal flow with a real installer
  (Calamares) that sets up disks, users, keyboard and timezone in one window.
- **Signed packages and ISO:** a GPG key for the [smlinux] repository and the ISO, so
  `SigLevel` can be `Required` instead of `Optional TrustAll`.
- **Smaller download:** an ISO under 2 GB so it downloads as one file.
- **Automated ISO build in CI**, with a QEMU boot test that screenshots the login screen.

## Should have
- A Settings app for Hyprland that doesn't need a terminal (Wi-Fi, display scaling, keyboard).
- Display arrangement for multiple monitors in Hyprland.
- Live wallpaper pauses when it's fully covered by windows, not just for fullscreen apps.
- Translations for the SMLinux scripts and dialogs.
