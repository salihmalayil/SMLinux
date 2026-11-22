#!/usr/bin/env bash
# Build the SMLinux-Ubuntu live ISO from scratch (debootstrap + casper + GRUB).
# Run as root on Ubuntu or Debian:
#   sudo bash scripts/build-iso.sh            # default: Ubuntu 26.04 "resolute"
#   sudo SUITE=noble bash scripts/build-iso.sh
#
# STATUS: experimental, not yet run end to end. Expect to fix things on the first run.
# Needs: debootstrap squashfs-tools xorriso grub-pc-bin grub-efi-amd64-bin mtools
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
SUITE="${SUITE:-resolute}"
MIRROR="${MIRROR:-http://archive.ubuntu.com/ubuntu}"
WORK="${WORK:-/var/tmp/smlinux-ubuntu}"
CHROOT="$WORK/chroot"
ISO_DIR="$WORK/iso"
OUT="$HERE/out"
VERSION="0.1"

[[ $EUID -eq 0 ]] || { echo "Run as root"; exit 1; }
for t in debootstrap mksquashfs xorriso grub-mkrescue; do
    command -v "$t" >/dev/null || { echo "Missing tool: $t"; exit 1; }
done
list() { sed 's/#.*//; /^[[:space:]]*$/d' "$1"; }

cleanup() {
    for m in dev/pts dev proc sys run; do umount -lf "$CHROOT/$m" 2>/dev/null || true; done
}
trap cleanup EXIT

echo "==> Bootstrapping Ubuntu $SUITE"
rm -rf "$WORK"; mkdir -p "$CHROOT" "$ISO_DIR/casper" "$OUT"
debootstrap --arch=amd64 --variant=minbase "$SUITE" "$CHROOT" "$MIRROR"

for m in dev dev/pts proc sys run; do mount --bind "/$m" "$CHROOT/$m"; done
cat > "$CHROOT/etc/apt/sources.list" <<EOF
deb $MIRROR $SUITE main restricted universe multiverse
deb $MIRROR $SUITE-updates main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu $SUITE-security main restricted universe multiverse
EOF

in_chroot() { chroot "$CHROOT" /usr/bin/env DEBIAN_FRONTEND=noninteractive "$@"; }

echo "==> Installing the system and the SMLinux package list"
in_chroot apt-get update
in_chroot apt-get install -y --no-install-recommends \
    linux-generic casper systemd-sysv sudo locales ca-certificates
mapfile -t pkgs < <(list "$HERE/profile/packages.list")
in_chroot apt-get install -y "${pkgs[@]}"

echo "==> Compiling the SMLinux shell inside the image"
mapfile -t bdeps < <(list "$HERE/profile/build-deps.list")
in_chroot apt-get install -y --no-install-recommends "${bdeps[@]}"
mkdir -p "$CHROOT/tmp/shell"
cp -r "$HERE/source/desktop/shell/." "$CHROOT/tmp/shell/"
in_chroot sh -c 'cmake -S /tmp/shell -B /tmp/shell/build -G Ninja -DCMAKE_BUILD_TYPE=Release \
                 && cmake --build /tmp/shell/build \
                 && install -Dm755 /tmp/shell/build/smlinux-shell /usr/bin/smlinux-shell'
in_chroot apt-get purge -y --auto-remove "${bdeps[@]}"
rm -rf "$CHROOT/tmp/shell"

echo "==> SMLinux files"
cp -a "$HERE/profile/overlay/." "$CHROOT/"
chmod 755 "$CHROOT/usr/bin/smlinux-session"
install -Dm644 "$HERE/branding/smlinux-wallpaper.svg" "$CHROOT/usr/share/backgrounds/smlinux-wallpaper.svg"
in_chroot systemctl enable sddm NetworkManager
in_chroot apt-get clean
rm -rf "$CHROOT/var/lib/apt/lists/"*

echo "==> Packing the live filesystem"
cp "$CHROOT"/boot/vmlinuz-* "$ISO_DIR/casper/vmlinuz"
cp "$CHROOT"/boot/initrd.img-* "$ISO_DIR/casper/initrd"
cleanup
mksquashfs "$CHROOT" "$ISO_DIR/casper/filesystem.squashfs" -comp xz -noappend -e boot
du -sx --block-size=1 "$CHROOT" | cut -f1 > "$ISO_DIR/casper/filesystem.size"

mkdir -p "$ISO_DIR/boot/grub"
cat > "$ISO_DIR/boot/grub/grub.cfg" <<'EOF'
set timeout=5
menuentry "SMLinux-Ubuntu (live)" {
    linux /casper/vmlinuz boot=casper quiet splash ---
    initrd /casper/initrd
}
menuentry "SMLinux-Ubuntu (live, safe graphics)" {
    linux /casper/vmlinuz boot=casper nomodeset ---
    initrd /casper/initrd
}
EOF

echo "==> Making the ISO (BIOS + UEFI)"
grub-mkrescue -o "$OUT/smlinux-ubuntu-$VERSION-amd64.iso" "$ISO_DIR" -- -volid SMLINUX_UBUNTU
(cd "$OUT" && sha256sum "smlinux-ubuntu-$VERSION-amd64.iso" > SHA256SUMS)
ls -lh "$OUT"
