#!/usr/bin/env bash
# Build the SMLinux-Arch ISO. Run as root on Arch Linux (bare metal, VM, or Arch in WSL):
#   sudo bash build.sh
#
# Options (environment variables):
#   SMLINUX_SNAPSHOT=YYYY/MM/DD   Build from the Arch Linux Archive snapshot of that day,
#                                 so the same command always gives the same package
#                                 versions (reproducible builds).
#
# Output (out/):
#   smlinux-<version>-x86_64.iso       the ISO
#   SHA256SUMS                         checksums
#   pkglist-<version>.txt              exact package versions inside the ISO
#   repo/                              the [smlinux] pacman repository (db + package)
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(tr -d '[:space:]' < "$HERE/VERSION")"
WORK="/var/tmp/smlinux-build"     # Linux filesystem (NTFS can't hold Linux permissions)
PROFILE="$WORK/profile"
REPO="$WORK/repo"
OUTDIR="$HERE/out"

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo bash build.sh"; exit 1; }
clean_list() { sed 's/\r$//; s/#.*//; s/[[:space:]]*$//; /^$/d' "$1"; }
strip_crlf() { { grep -rIl $'\r' "$1" 2>/dev/null || true; } | xargs -r sed -i 's/\r$//'; }

echo "==> Updating the build machine and installing build tools"
pacman -Syu --needed --noconfirm archiso base-devel librsvg breeze pacman-contrib

rm -rf "$WORK"
mkdir -p "$PROFILE" "$REPO" "$OUTDIR"

# ── 1. The smlinux-desktop package and its repository ──────────────────────
echo "==> Building the smlinux-desktop package ($VERSION)"
id smlbuild >/dev/null 2>&1 || useradd --system --create-home --home-dir /var/tmp/smlbuild-home smlbuild
cp -r "$HERE/pkg/smlinux-desktop" "$WORK/pkg"
cp "$HERE/LICENSE" "$WORK/pkg/LICENSE"
strip_crlf "$WORK/pkg"
sed -i "s/^pkgver=.*/pkgver=$VERSION/" "$WORK/pkg/PKGBUILD"
chown -R smlbuild: "$WORK/pkg"
(cd "$WORK/pkg" && runuser -u smlbuild -- makepkg --force --nodeps --cleanbuild)
cp "$WORK"/pkg/smlinux-desktop-*.pkg.tar.zst "$REPO/"
repo-add "$REPO/smlinux.db.tar.gz" "$REPO"/smlinux-desktop-*.pkg.tar.zst

# ── 2. ISO profile: Arch's official releng profile + SMLinux ───────────────
echo "==> Starting from the official Arch 'releng' profile"
cp -r /usr/share/archiso/configs/releng/. "$PROFILE/"

echo "==> Package list"
# Drop releng's rescue/server tools that a desktop ISO doesn't need (keeps the ISO smaller)
grep -vxF -f <(clean_list "$HERE/packages.remove") "$PROFILE/packages.x86_64" > "$WORK/packages.tmp" || true
clean_list "$HERE/packages.iso" >> "$WORK/packages.tmp"
sort -u "$WORK/packages.tmp" > "$PROFILE/packages.x86_64"

# The ISO build installs smlinux-desktop from the local repository
cat >> "$PROFILE/pacman.conf" <<EOF

[smlinux]
SigLevel = Optional TrustAll
Server = file://$REPO
EOF
if [[ -n ${SMLINUX_SNAPSHOT:-} ]]; then
    echo "==> Pinning packages to the Arch Linux Archive snapshot of $SMLINUX_SNAPSHOT"
    sed -i "s|^Include = /etc/pacman.d/mirrorlist|Server = https://archive.archlinux.org/repos/$SMLINUX_SNAPSHOT/\$repo/os/\$arch|" \
        "$PROFILE/pacman.conf"
fi

echo "==> Copying the live-USB files"
cp -a "$HERE/airootfs/." "$PROFILE/airootfs/"
strip_crlf "$PROFILE/airootfs"
# The installer installs smlinux-desktop from this copy on the ISO
mkdir -p "$PROFILE/airootfs/opt/smlinux-repo"
cp -L "$REPO"/* "$PROFILE/airootfs/opt/smlinux-repo/"

echo "==> Services"
SYS="$PROFILE/airootfs/etc/systemd/system"
WANTS="$SYS/multi-user.target.wants"
mkdir -p "$WANTS"
# Security: no SSH server on the live USB (the live password is public)
rm -f "$WANTS/sshd.service"
# NetworkManager instead of releng's systemd-networkd + iwd
rm -f "$WANTS/systemd-networkd.service" "$WANTS/iwd.service" \
      "$SYS/sockets.target.wants/systemd-networkd.socket" \
      "$SYS/network-online.target.wants/systemd-networkd-wait-online.service"
# cloud-init is removed from the package list, so drop its services too
find "$SYS" -name 'cloud-*' -exec rm -rf {} +
ln -sf /usr/lib/systemd/system/NetworkManager.service "$WANTS/NetworkManager.service"
ln -sf /usr/lib/systemd/system/bluetooth.service      "$WANTS/bluetooth.service"
ln -sf /usr/lib/systemd/system/ufw.service            "$WANTS/ufw.service"
ln -sf /usr/lib/systemd/system/power-profiles-daemon.service "$WANTS/power-profiles-daemon.service"
ln -sf /etc/systemd/system/smlinux-liveuser.service   "$WANTS/smlinux-liveuser.service"
# Graphical login screen (SDDM) instead of a text console
ln -sf /usr/lib/systemd/system/sddm.service "$SYS/display-manager.service"
ln -sf /usr/lib/systemd/system/graphical.target "$SYS/default.target"

echo "==> Branding"
sed -i \
  -e 's/^iso_name=.*/iso_name="smlinux"/' \
  -e 's/^iso_label=.*/iso_label="SMLINUX_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"/' \
  -e 's/^iso_publisher=.*/iso_publisher="SMLinux <https:\/\/github.com\/salihmalayil\/SMLinux>"/' \
  -e "s/^iso_version=.*/iso_version=\"$VERSION\"/" \
  -e 's/^iso_application=.*/iso_application="SMLinux Live\/Install Medium"/' \
  "$PROFILE/profiledef.sh"
cat >> "$PROFILE/profiledef.sh" <<'EOF'
file_permissions+=(
  ["/usr/local/bin/smlinux-install"]="0:0:755"
  ["/usr/local/bin/smlinux-create-liveuser"]="0:0:755"
  ["/etc/sudoers.d/10-liveuser"]="0:0:440"
)
EOF
# Boot menu text and artwork: "Arch Linux" → "SMLinux", SMLinux splash image
{ grep -rl "Arch Linux" "$PROFILE"/{syslinux,efiboot,grub} 2>/dev/null || true; } \
  | xargs -r sed -i 's/Arch Linux/SMLinux/g'
rsvg-convert -w 640 -h 480 "$HERE/iso/splash.svg" -o "$PROFILE/syslinux/splash.png"

# ── 3. Build ────────────────────────────────────────────────────────────────
echo "==> Building the ISO (this takes a while)"
rm -f "$OUTDIR/smlinux-$VERSION-x86_64.iso"
mkarchiso -v -w "$WORK/work" -o "$OUTDIR" "$PROFILE"
ISO="$OUTDIR/smlinux-$VERSION-x86_64.iso"
[[ -f $ISO ]] || { echo "No ISO was produced"; exit 1; }

echo "==> Release files"
rm -rf "$OUTDIR/repo"; mkdir -p "$OUTDIR/repo"
cp -L "$REPO/smlinux.db.tar.gz"    "$OUTDIR/repo/smlinux.db"
cp -L "$REPO/smlinux.files.tar.gz" "$OUTDIR/repo/smlinux.files"
cp "$REPO"/smlinux-desktop-*.pkg.tar.zst "$OUTDIR/repo/"
cp "$WORK/work/iso/arch/pkglist.x86_64.txt" "$OUTDIR/pkglist-$VERSION.txt"
(cd "$OUTDIR" && sha256sum "smlinux-$VERSION-x86_64.iso" > SHA256SUMS)

echo "==> Done:"
ls -lh "$ISO"
cat "$OUTDIR/SHA256SUMS"
