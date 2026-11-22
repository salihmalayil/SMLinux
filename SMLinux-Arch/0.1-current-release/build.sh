#!/usr/bin/env bash
# Build the SMLinux ISO. Run as root on Arch Linux (bare metal, VM, or Arch in WSL).
#   sudo bash build.sh
# Output: ./out/smlinux-YYYY.MM.DD-x86_64.iso
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# Build on a real Linux filesystem (never on /mnt/c - NTFS breaks permissions/symlinks).
WORK="/var/tmp/smlinux-build"
PROFILE="$WORK/profile"
OUTDIR="$HERE/out"

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo bash build.sh"; exit 1; }

echo "==> Installing archiso"
pacman -Sy --needed --noconfirm archiso

echo "==> Starting from the official Arch 'releng' profile"
rm -rf "$WORK"
mkdir -p "$PROFILE"
cp -r /usr/share/archiso/configs/releng/. "$PROFILE/"

echo "==> Adding SMLinux packages"
grep -v '^\s*#' "$HERE/packages.smlinux" | sed 's/\r$//; /^\s*$/d' >> "$PROFILE/packages.x86_64"
sort -u -o "$PROFILE/packages.x86_64" "$PROFILE/packages.x86_64"

echo "==> Copying SMLinux files into the live system"
cp -a "$HERE/airootfs/." "$PROFILE/airootfs/"
mkdir -p "$PROFILE/airootfs/usr/share/smlinux"
grep -v '^\s*#' "$HERE/packages.smlinux" | sed 's/\r$//; /^\s*$/d' > "$PROFILE/airootfs/usr/share/smlinux/packages.txt"
# Files edited on Windows may have CRLF line endings - normalise every text file.
{ grep -rIl $'\r' "$PROFILE/airootfs" 2>/dev/null || true; } | xargs -r sed -i 's/\r$//'

echo "==> Enabling services"
WANTS="$PROFILE/airootfs/etc/systemd/system/multi-user.target.wants"
mkdir -p "$WANTS"
# releng uses systemd-networkd + iwd; SMLinux uses NetworkManager.
rm -f "$WANTS/systemd-networkd.service" "$WANTS/iwd.service" \
      "$PROFILE/airootfs/etc/systemd/system/sockets.target.wants/systemd-networkd.socket" \
      "$PROFILE/airootfs/etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service"
ln -sf /usr/lib/systemd/system/NetworkManager.service "$WANTS/NetworkManager.service"
ln -sf /usr/lib/systemd/system/bluetooth.service      "$WANTS/bluetooth.service"
ln -sf /etc/systemd/system/smlinux-liveuser.service   "$WANTS/smlinux-liveuser.service"

echo "==> Branding"
sed -i \
  -e 's/^iso_name=.*/iso_name="smlinux"/' \
  -e 's/^iso_label=.*/iso_label="SMLINUX_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"/' \
  -e 's/^iso_publisher=.*/iso_publisher="SMLinux"/' \
  -e 's/^iso_version=.*/iso_version="0.1"/' \
  -e 's/^iso_application=.*/iso_application="SMLinux Live\/Install Medium"/' \
  "$PROFILE/profiledef.sh"
cat >> "$PROFILE/profiledef.sh" <<'EOF'
file_permissions+=(
  ["/usr/local/bin/smlinux-install"]="0:0:755"
  ["/usr/local/bin/smlinux-create-liveuser"]="0:0:755"
  ["/usr/local/bin/smlinux-power"]="0:0:755"
  ["/usr/local/bin/smlinux-settings"]="0:0:755"
  ["/usr/local/bin/smlinux-screenshot"]="0:0:755"
  ["/usr/local/bin/smlinux-switch-desktop"]="0:0:755"
  ["/usr/local/bin/smlinux-wallpaper"]="0:0:755"
  ["/usr/local/bin/smlinux-plasma-setup"]="0:0:755"
  ["/etc/skel/Desktop/smlinux-switch.desktop"]="0:0:755"
  ["/etc/sudoers.d/10-liveuser"]="0:0:440"
)
EOF
# Boot menu text: "Arch Linux" -> "smlinux"
{ grep -rl "Arch Linux" "$PROFILE"/{syslinux,efiboot,grub} 2>/dev/null || true; } \
  | xargs -r sed -i 's/Arch Linux/SMLinux/g'

echo "==> Building ISO (this takes a while)"
mkdir -p "$OUTDIR"
mkarchiso -v -w "$WORK/work" -o "$OUTDIR" "$PROFILE" || { echo "mkarchiso failed"; exit 1; }
ls "$OUTDIR"/smlinux-*.iso >/dev/null 2>&1 || { echo "No ISO was produced"; exit 1; }

echo "==> Done:"
ls -lh "$OUTDIR"/*.iso
