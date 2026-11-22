#!/usr/bin/env bash
# Automated checks for SMLinux-Arch. Runs on Arch Linux (CI uses the
# archlinux container). Needs: shellcheck hyprland qt6-declarative python
#   bash scripts/check.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
ROOT=pkg/smlinux-desktop/root
fail=0
ok()  { echo "  ok    $*"; }
bad() { echo "  FAIL  $*"; fail=1; }

echo "== Shell scripts (bash -n + shellcheck)"
scripts=(build.sh scripts/check.sh "$ROOT"/usr/bin/* airootfs/usr/local/bin/*)
for f in "${scripts[@]}"; do
    if bash -n "$f" && shellcheck -S warning -s bash "$f"; then ok "$f"; else bad "$f"; fi
done

echo "== JSON / JSONC files"
while IFS= read -r f; do
    if python3 - "$f" <<'EOF'
import json, re, sys
text = open(sys.argv[1], encoding="utf-8").read()
text = re.sub(r'^\s*//.*$', '', text, flags=re.M)     # JSONC line comments
json.loads(text)
EOF
    then ok "$f"; else bad "$f"; fi
done < <(find "$ROOT" -name '*.json' -o -name '*.jsonc')

echo "== Hyprland config (as a real login loads it, via the user template)"
tmp=$(mktemp -d)
cp "$ROOT/usr/share/smlinux/hypr/smlinux.lua" "$tmp/"
sed "s#/usr/share/smlinux/hypr/#$tmp/#" "$ROOT/usr/share/smlinux/hypr/user-template.lua" > "$tmp/user.lua"
export XDG_RUNTIME_DIR="$tmp/run"; mkdir -m 700 "$XDG_RUNTIME_DIR"
for mode in "SMLINUX_LIVE=1 SMLINUX_VM=1" "SMLINUX_LIVE=0 SMLINUX_VM=0 SMLINUX_KB_LAYOUT=de"; do
    out=$(env $mode Hyprland --i-am-really-stupid --verify-config -c "$tmp/user.lua" 2>&1)
    if grep -q "config ok" <<<"$out"; then ok "hyprland.lua ($mode)"; else bad "hyprland.lua ($mode)"; echo "$out" | tail -n 15; fi
done
rm -rf "$tmp"

echo "== QML"
qml="$ROOT/usr/share/plasma/wallpapers/org.smlinux.liquid/contents/ui/LiquidScene.qml"
if /usr/lib/qt6/bin/qmllint "$qml"; then ok "$qml"; else bad "$qml"; fi

echo "== Desktop entries"
while IFS= read -r f; do
    if grep -q '^\[Desktop Entry\]' "$f" && grep -q '^Exec=' "$f" && grep -q '^Name=' "$f"; then ok "$f"; else bad "$f"; fi
done < <(find "$ROOT" airootfs -name '*.desktop')

echo
if (( fail )); then echo "Some checks FAILED"; exit 1; fi
echo "All checks passed"
