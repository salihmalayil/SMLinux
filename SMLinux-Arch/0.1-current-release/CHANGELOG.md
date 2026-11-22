# Changelog

## 0.1.1 "Dawn" (2026-11-22)

A big fix-up release based on a full review of 0.1 (numbers refer to that review).
**0.1 is withdrawn:** its Hyprland config didn't load on Hyprland 0.57.

### 🔴 Security and installer
- **SSH is off on the live USB** (#1). Arch's base profile enabled it, and with the public
  live password anyone on your network could log in. The firewall (ufw) is also on, live and installed (#49).
- **No more partial upgrades** (#2, #57, #19). The installer refreshes the signing keys, then
  does a full `pacman -Syu` before installing anything. The build does the same, and
  Settings → Update does keys + full upgrade.
- **Installs that leave you without a desktop are fixed** (#3). The installer now mounts the
  new system exactly as its own fstab describes, so **btrfs subvolumes (`@home`), a separate
  `/home`, `/boot` and LUKS-encrypted disks** all work. Your desktop no longer depends on files
  copied into your home folder at all (see "pacman package" below).
- **No live-USB text on installed systems** (#4). The live password message exists only on the USB.
- **Sound and hardware support on installed systems** (#5). `sof-firmware`, `alsa-firmware`,
  `ntfs-3g`, `exfatprogs` and more are now dependencies of the SMLinux package.
- **NVIDIA support** (#6). The installer detects NVIDIA cards and installs the matching driver
  (`nvidia-open` / `-lts` / `-dkms`), and the session sets NVIDIA's environment variables.
  On the live USB, NVIDIA machines start in KDE Plasma (nouveau runs Hyprland badly).
- **The installer stops loudly on any failure** (#10) instead of printing "Done!", and
  `--resume` retries. It **keeps your hostname** (#11), switches off other network managers
  so only NetworkManager runs (#12), and applies your keyboard layout to the desktops (#22).

### 🟠 How SMLinux is put together
- **SMLinux is now a real pacman package, `smlinux-desktop`** (#8). pacman knows every
  SMLinux file, so it can update, repair (`pacman -S smlinux-desktop`) or remove them.
  Installed systems get the **[smlinux] repository**, so fixes arrive with `pacman -Syu`.
- **Config fixes reach existing users** (#9). Your `~/.config/hypr/hyprland.lua` just loads
  SMLinux's defaults from the package, then your own changes. It's created at login for any
  account, including accounts made without `/etc/skel`.
- **One source of truth** (#7). The stale local copy is gone; everything lives in this repo.

### 🟠 Login and desktops
- **Graphical login screen (SDDM)** (#13) with the two SMLinux sessions and the SMLinux
  wallpaper. KDE Wallet unlocks at login, so Wi-Fi passwords aren't asked for again (#42).
- **Crash fallback fixed** (#14, #32). A normal logout never flips your desktop, however quick.
  Only a real crash (error exit) in the first minute switches the next login to the other desktop.
- **Switching desktops no longer kills apps** (#15). Apps are asked to close (Hyprland:
  hyprshutdown, KDE: normal logout), so you can save. On an installed system the login screen
  opens with the other desktop selected. KDE also gets **Meta+K** to switch back (#40).
- **Bluetooth tray icon in Hyprland** (#16) and no duplicate icon in KDE.
- **Qt apps are dark in Hyprland too** (#17): system-wide Breeze Dark defaults + KDE platform theme.
  GTK4/libadwaita apps are dark as well.
- **File pickers and screen sharing pick the right portal** in Hyprland (#18).
- **"Update system" is hidden on the live USB** (#20), where it would fill the RAM disk.

### 🟡 Desktop and usability
- Display scaling is automatic for high-res screens (#21).
- **Wi-Fi:** the network pill and Settings → Wi-Fi open a network picker that scans and
  connects (#23).
- **The dock shows your open windows** (click to focus, middle-click to close) (#24) and
  **Super+D hides/shows it** (#25).
- The bar shows 6 workspaces, matching the keys (#26). **3-finger swipe** changes workspace (#27).
- **Volume and brightness pop-ups** (#28). **Suspend after 30 min idle** (#29).
- **Power modes** (power-profiles-daemon) with a bar button and Settings entry (#30).
- **Power menu:** Suspend and (when possible) Hibernate added; Log out, Restart and Shut down
  ask first and close apps gracefully (#31). Super+Shift+M opens this menu instead of exiting (#32).
- Software cursors only in virtual machines (#33). Windows are fully opaque again (#34).
  Only specific utility windows are centred (#35), and the network editor isn't stretched (#36).
- **The live session never locks** and its welcome message shows the password (#37).
- **fastfetch shows in every terminal window, with an SMLinux logo** (#38, #39).
- KDE: dark theme and accent are right from the first login, and setup retries if it fails (#41).
  The KDE lock screen uses the SMLinux wallpaper (#43).
- **Apps:** image viewer (Gwenview), PDF viewer (Okular), video player (Haruna), text editor
  (Kate), app store (Discover + Flathub) (#44).
- **Chinese, Japanese and Korean text** displays properly (#45). Intel hardware video decoding (#46).
  Outdated `xf86-video-intel` removed (#47). **Printing** (CUPS + KDE printer settings) (#48).
- **Clipboard history** (Super+C), **colour picker** (Super+Shift+C), **Do Not Disturb**
  (Super+N or the bell in the bar) (#50).

### 🟡 Live wallpaper
- **Much lighter on the GPU** (#51): capped at 30 fps (20 in battery-saver quality), blur
  rendered at half resolution, fixed-size stage so 4K costs the same as 1080p.
- **Pauses** during fullscreen apps and on battery (#52).
- **Every monitor** gets the animation, including ones plugged in later (#53).
- Can't be tiled like a normal window any more: shown only after its layer settings apply (#54).
- **No stretching** on ultrawide or 16:10 screens (#55).
- **KDE settings page:** pause, speed, quality (#56).

### 🟡 Build and release
- ISO named with its real version and a date-stamped build ID (#59).
- **Reproducible builds:** `SMLINUX_SNAPSHOT=YYYY/MM/DD` pins packages to that day's Arch
  archive, and every release publishes the exact package list (#60).
- Boot menu uses SMLinux artwork, not Arch's logo (#62).
- `os-release` points to this repo and has bug-report/support links (#63).
- **Automated checks** (`scripts/check.sh` + GitHub Actions): shellcheck, JSON, Hyprland
  config, QML, desktop entries (#64).
- Releng's rescue/server tools (Clonezilla, cloud-init, nmap…) are removed to keep the ISO small (#58).

### ⚪ Docs (whole repo)
- The package list no longer contradicts itself (#66). The name is consistently **SMLinux** (#67).
- Debian, 1.0 and 2.0 pages now say honestly what exists and what's planned, with a real roadmap (#68).
- **One MIT license for the whole repository** (#69). The Ubuntu README's broken link is fixed (#70).

### 🟣 Ubuntu prototype
- The clock updates every second (#71). "Online" reflects the real network state (#72).
- **Search finds any installed app** (#73). The shell now sits under app windows, with a
  taskbar (tint2) to switch between them (#74).
- The installer tile finds whichever Ubuntu installer exists (#75). Tiles for apps that
  aren't installed are hidden.
- Developer tools and Wine are out of the user package list (#76).
- **ISO build script** added (#77): experimental, not yet run end to end.

### Still open
- **Not tested on real hardware yet** (#65). It's checked in a virtual machine only.
- **No GPG signatures yet** (#61). Releases have SHA-256 checksums, and the [smlinux] repo
  uses `SigLevel = Optional TrustAll`. Signing needs a project GPG key.
- The live wallpaper pauses for fullscreen apps and battery, but not yet when windows simply cover it (#52).

## 0.1 "Dawn" (2026-11-22), withdrawn

First Arch-based SMLinux: Hyprland + KDE Plasma, one-button switching, live wallpaper,
archinstall-based installer. Withdrawn because Hyprland 0.57 ignored its `hyprland.conf`.
