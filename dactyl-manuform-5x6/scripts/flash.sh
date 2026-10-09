#!/bin/bash
# Flash one half of the keyboard. Needs two bootloader entries on the SAME half:
#   round 1: read EEPROM only and check the handedness byte (offset 14: left=01, right=00)
#   round 2: write the firmware and the handedness EEPROM file
# avrdude makes the bootloader exit after each run, so check and write cannot share one entry.
#
# usage: scripts/flash.sh <left|right> [hex] [expected-byte]
#   hex            defaults to firmware/dactyl_manuform_5x6.hex
#   expected-byte  override the check, e.g. 01 when a right half was flashed as left by mistake
set -uo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
side=${1:-}; hex=${2:-$here/firmware/dactyl_manuform_5x6.hex}
case $side in
  left)  want=01; eep=$here/firmware/eeprom-lefthand.eep ;;
  right) want=00; eep=$here/firmware/eeprom-righthand.eep ;;
  *) echo "usage: $0 <left|right> [hex] [expected-byte]"; exit 2 ;;
esac
[ -n "${3:-}" ] && want=$3
tmp=$(mktemp -d)

# Wait (about 5 min) for a new /dev/cu.usbmodem* port: the Caterina bootloader (stays ~8 s).
wait_port() {
  local before p i
  before=$(ls /dev/cu.usbmodem* 2>/dev/null)
  for i in $(seq 1 3000); do
    for p in $(ls /dev/cu.usbmodem* 2>/dev/null); do
      grep -qx "$p" <<<"$before" || { sleep 0.5; echo "$p"; return 0; }
    done
    before=$(ls /dev/cu.usbmodem* 2>/dev/null); sleep 0.1
  done
  return 1
}

echo "ROUND 1 ($side): reboot the $side half to the bootloader (Vial: Security -> Reboot to bootloader)"
p=$(wait_port) || { echo "timed out"; exit 1; }
avrdude -q -q -p m32u4 -c avr109 -P "$p" -U eeprom:r:"$tmp/ee.bin":r
got=$(xxd -s 14 -l 1 -p "$tmp/ee.bin")
echo "handedness byte: $got (expected $want)"
[ "$got" = "$want" ] || { echo "ABORT: this is not the $side half. Nothing was written."; exit 3; }

echo "ROUND 2 ($side): verified. Reboot the SAME half to the bootloader again to flash"
sleep 3
p=$(wait_port) || { echo "timed out"; exit 1; }
avrdude -p m32u4 -c avr109 -P "$p" -U flash:w:"$hex":i -U eeprom:w:"$eep":i
