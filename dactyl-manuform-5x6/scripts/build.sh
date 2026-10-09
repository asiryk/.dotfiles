#!/bin/bash
# Build the Vial firmware from ../keymap and copy the .hex to ../firmware.
#
# usage: scripts/build.sh [vial-qmk-dir]
#   vial-qmk-dir defaults to $VIAL_QMK_DIR or ~/.cache/vial-qmk.
#   If the directory does not exist, vial-qmk is cloned at the pinned commit.
set -euo pipefail

VIAL_QMK_COMMIT=dd43959ae5c08d8a28d38a1acf7b04e86b14a344
here=$(cd "$(dirname "$0")/.." && pwd)
qmk_dir=${1:-${VIAL_QMK_DIR:-$HOME/.cache/vial-qmk}}
target=handwired/dactyl_manuform/5x6
keymap=asiryk

# avr-gcc@8 is keg-only in Homebrew, so it is not on PATH by default.
export PATH=/opt/homebrew/opt/avr-gcc@8/bin:/opt/homebrew/opt/avr-binutils/bin:$PATH
command -v avr-gcc >/dev/null || { echo "avr-gcc not found: brew tap osx-cross/avr && brew install osx-cross/avr/avr-gcc@8 avrdude"; exit 1; }
command -v qmk >/dev/null || { echo "qmk CLI not found: uv tool install qmk"; exit 1; }

if [ ! -d "$qmk_dir/.git" ]; then
  echo "Cloning vial-qmk into $qmk_dir"
  git init -q "$qmk_dir"
  git -C "$qmk_dir" remote add origin https://github.com/vial-kb/vial-qmk.git
fi
if [ "$(git -C "$qmk_dir" rev-parse HEAD 2>/dev/null)" != "$VIAL_QMK_COMMIT" ]; then
  git -C "$qmk_dir" fetch -q --depth 1 origin "$VIAL_QMK_COMMIT"
  git -C "$qmk_dir" checkout -q "$VIAL_QMK_COMMIT"
  git -C "$qmk_dir" submodule update -q --init --depth 1 --recursive
fi

dest="$qmk_dir/keyboards/$target/keymaps/$keymap"
rm -rf "$dest"
cp -R "$here/keymap" "$dest"

make -C "$qmk_dir" "$target:$keymap"
cp "$qmk_dir/${target//\//_}_$keymap.hex" "$here/firmware/dactyl_manuform_5x6.hex"
echo "Firmware: $here/firmware/dactyl_manuform_5x6.hex"
