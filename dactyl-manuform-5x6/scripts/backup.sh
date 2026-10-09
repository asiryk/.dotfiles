#!/bin/bash
# Read (never write) the flash and EEPROM of one half into <outdir>/<name>-flash.hex and <name>-eeprom.hex.
#
# usage: scripts/backup.sh <name> [outdir]
#   e.g. scripts/backup.sh left ~/Desktop
#   Start it, then reboot the half to the bootloader (Vial: Security -> Reboot to bootloader).
set -uo pipefail

here=$(cd "$(dirname "$0")/.." && pwd)
name=${1:?usage: $0 <name> [outdir]}; out=${2:-$here/backup}
mkdir -p "$out"

before=$(ls /dev/cu.usbmodem* 2>/dev/null)
echo "waiting for bootloader..."
for i in $(seq 1 3000); do
  for p in $(ls /dev/cu.usbmodem* 2>/dev/null); do
    if ! grep -qx "$p" <<<"$before"; then
      sleep 0.5
      avrdude -p m32u4 -c avr109 -P "$p" -U flash:r:"$out/$name-flash.hex":i -U eeprom:r:"$out/$name-eeprom.hex":i
      exit $?
    fi
  done
  before=$(ls /dev/cu.usbmodem* 2>/dev/null); sleep 0.1
done
echo "timed out"; exit 1
