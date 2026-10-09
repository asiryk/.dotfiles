# Dactyl Manuform 5x6

Dactyl Manuform 5x6 split keyboard with a 5-key thumb cluster, wired TRRS link between the halves,
USB-C on each half, RGB underglow. It runs a custom [Vial](https://get.vial.today) build of QMK,
configured live in Vial (desktop app or https://vial.rocks).

This folder has everything to rebuild, reflash, back up and restore the keyboard.

```
keymap/     QMK keymap "asiryk" (config.h, rules.mk, keymap.c, vial.json) - the firmware source
firmware/   dactyl_manuform_5x6.hex - the exact firmware on the keyboard now (flashed 2026-10-09)
            eeprom-{left,right}hand.eep - QMK files that write the handedness byte
layout.vil  Vial layout (keymap, combos, ...) for this firmware
backup/     original firmware and EEPROM of both halves, read before the first reflash
scripts/    build.sh, flash.sh, backup.sh
```

## Hardware

| Item | Value |
|---|---|
| Controller | Pro Micro 5V, ATmega32U4, one in each half |
| Bootloader | Caterina. In bootloader mode it shows as "Pro Micro 5V" (SparkFun, `1B4F:9205`) for about 8 s, then starts the firmware again |
| Flash | 28672 bytes for firmware (the bootloader uses the last 4 KB) |
| EEPROM | 1024 bytes. Byte 14 is the handedness: `01` = left, `00` = right |
| USB ID (firmware) | `444D:3536`, product "Dactyl-Manuform (5x6)" |
| Matrix | 12 rows x 6 cols (6 rows per half), `COL2ROW` |
| Row pins | F6 F7 B1 B3 B2 B6 |
| Column pins | D4 C6 D7 E6 B4 B5 |
| Link between halves | Serial on pin D0, through the TRRS cable |
| RGB underglow | WS2812 on pin D1, 24 LEDs, 12 per half (`RGBLED_SPLIT {12, 12}`) |
| Thumb cluster | 5 keys per side. Matrix positions `4,5` (left) and `10,0` (right) are not wired |

The pins and LED settings are the stock QMK `handwired/dactyl_manuform/5x6` values, except the RGB pin and
LED count.

## Firmware

- Source: [vial-qmk](https://github.com/vial-kb/vial-qmk), commit `dd43959ae5c08d8a28d38a1acf7b04e86b14a344`
- Target: `handwired/dactyl_manuform/5x6`, keymap `asiryk` (this `keymap/` folder)
- Vial keyboard UID: `B7183CFE44C4B6C4`
- Size: 27676 / 28672 bytes (996 bytes free)

The ATmega32U4 is very small, so not all Vial features fit at the same time. This build has:

| Enabled | Disabled (no space) |
|---|---|
| RGB underglow, all effects (Breathing, Rainbow Mood, Swirl, Snake, Knight, Christmas, Gradient, RGB Test, Alternating) | QMK Settings tab (tap-hold timing, Auto Shift and so on; the QMK defaults are used, tapping term 200 ms) |
| Combos | Tap Dance |
| Key Override | Mouse keys |
| Caps Word | Repeat Key, Layer Lock |
| Macros, 4 layers, tri-layer keys (`Fn1` = `TL_LOWR`) | Command, Magic keycodes, Space Cadet, Grave Escape |
| `EE_HANDS`: each half stores its side, so either half can be connected to USB | |
| Bootmagic key (see below) | |

Approximate sizes for other choices:

| Variant | Size |
|---|---|
| This build (all RGB effects, Combos, Key Override, Caps Word) | 27676 |
| 3 RGB effects + Combos + Key Override + Caps Word + Tap Dance | 27912 |
| All RGB effects + QMK Settings only | 28036 |
| QMK Settings + RGB + Combos + Key Override + Caps Word | about 31400 (too large) |

All RGB effects together cost about 1.4 KB. QMK Settings costs about 3 KB. Tap Dance costs about 1.6 KB.

## Tools (macOS)

```fish
brew tap osx-cross/avr
brew install osx-cross/avr/avr-gcc@8 avrdude
uv tool install qmk
```

- `avr-gcc@8` is the version QMK recommends for AVR, because it makes the smallest firmware.
- It is keg-only, so it is not on `PATH`. `build.sh` adds `/opt/homebrew/opt/avr-gcc@8/bin` itself.
- Do not use `brew install qmk/qmk/qmk`. It also needs the ARM toolchain tap, and new Homebrew refuses
  to install it without extra taps.

## Safety nets

1. **Bootloader from Vial**: Security -> Reboot to bootloader. Vial can ask you to unlock first: hold
   Esc and 1 (top-left keys of the left half) until the bar is full.
2. **Bootmagic key**: hold the outer top key of a half while you connect USB to that half. Left half: the
   top-left key. Right half: the top-right key. That half starts in the bootloader. This also clears the
   EEPROM, so load `layout/dactyl.vil` again after it.
3. **RST to GND**: if nothing else works, open the case and connect the RST and GND pins of the Pro Micro
   two times quickly (tweezers or a wire). The bootloader starts. The bootloader is not changed by USB
   flashing, so the keyboard can always be flashed again.

## TRRS cable

Do not connect or disconnect the TRRS cable while USB is connected. When the plug moves, its contacts
touch the wrong pins for a moment and can make a short circuit. Firmware cannot prevent this.

- To disconnect: USB first, then TRRS.
- To connect: TRRS first, then USB.

## Procedures

### Build

```fish
scripts/build.sh                       # clones vial-qmk to ~/.cache/vial-qmk at the pinned commit
scripts/build.sh ~/path/to/vial-qmk    # or use an existing clone
```

The script copies `keymap/` into the vial-qmk tree, builds, and writes `firmware/dactyl_manuform_5x6.hex`.

Each build is different in about 10 bytes, because VIA puts the build date in its EEPROM magic number. So
when you flash a new build, the EEPROM is reset, and you must load the `.vil` layout again.

### Back up a half (read only)

```fish
scripts/backup.sh left ~/Desktop     # then: Vial -> Security -> Reboot to bootloader
```

### Flash

Do this one half at a time. **Use the same half for both rounds.**

1. Save the layout: Vial -> File -> Save current layout.
2. Disconnect USB. Keep TRRS connected. Connect USB to the half that you flash.
3. Run `scripts/flash.sh left` (or `right`).
4. Round 1: Vial -> Security -> Reboot to bootloader. The script reads EEPROM byte 14. If it is the wrong
   half, it stops and writes nothing. The keyboard starts again after about 8 s.
5. Round 2: on the **same half**, reboot to the bootloader again. The script writes the firmware and the
   handedness byte, and avrdude verifies them.
6. Do the other half.
7. Load the layout in Vial: File -> Load saved layout -> `layout/dactyl.vil`. Load it with each half
   connected to USB, because each half keeps its own copy of the keymap in its EEPROM.
8. Set the lighting again in the Lighting tab (it is not in the `.vil`). I use Rainbow Mood 1.

Two rounds are necessary because avrdude tells the Caterina bootloader to exit after each run.

If a half was flashed with the wrong handedness, it has the wrong byte now. Give the byte that it has now
as the third argument, for example `scripts/flash.sh right firmware/dactyl_manuform_5x6.hex 01`.

### Load a layout

- In Vial: File -> Load saved layout.
- The `.vil` file has the keyboard UID. If the UID is different from the firmware UID, desktop Vial asks
  "belongs to a different keyboard". The web version (vial.rocks) crashes at that question
  (`Uncaught ... emscripten_sleep`). To prevent this, set `"uid"` in the `.vil` to the firmware UID as a
  decimal number: `B7183CFE44C4B6C4` = `13193362171154970308`.
- Vial reads old key names (`KC_LSHIFT`, `FN_MO13` and so on) correctly.

### Go back to the original firmware

The `backup/original-*-app.hex` files contain only the application area (no bootloader), so they are safe
to write. With `flash.sh` they also get the correct handedness byte:

```fish
scripts/flash.sh left  backup/original-left-app.hex
scripts/flash.sh right backup/original-right-app.hex
```

To also put back the original EEPROM (layout and settings), run this during a bootloader entry:

```fish
avrdude -p m32u4 -c avr109 -P /dev/cu.usbmodemXXXX -U eeprom:w:backup/original-left-eeprom.hex:i
```

The `original-*-flash.hex` files are the full 32 KB dumps, including the bootloader. Keep them as a
record. Do not write them.

## Known problems

- **Vial "Reboot to bootloader" shows `AttributeError: 'hiddevice' object has no attribute 'close'`**
  (web Vial). This is a Vial bug. The reboot command was already sent, and the keyboard did reboot.
  Click OK.
- **Old Vial reported "Vial firmware too old"**. The original firmware used Vial protocol 4. The
  current build uses protocol 6.
