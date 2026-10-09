/* SPDX-License-Identifier: GPL-2.0-or-later */

#pragma once

#define VIAL_KEYBOARD_UID {0xC4, 0xB6, 0xC4, 0x44, 0xFE, 0x3C, 0x18, 0xB7}

#define VIAL_UNLOCK_COMBO_ROWS { 0, 0 }
#define VIAL_UNLOCK_COMBO_COLS { 0, 1 }

#define DYNAMIC_KEYMAP_LAYER_COUNT 4

// Each half stores its own side in EEPROM, so either half can be plugged into USB.
#define EE_HANDS

// Hold the outer top key of a half while plugging in USB to enter the bootloader
// (left: matrix 0,0; right: matrix 6,5). This also resets the saved keymap.
#define BOOTMAGIC_ROW_RIGHT 6
#define BOOTMAGIC_COLUMN_RIGHT 5

// RGB underglow as wired in this build: 12 LEDs per half on pin D1 (read from the original firmware)
#undef WS2812_DI_PIN
#define WS2812_DI_PIN D1
#undef RGBLIGHT_LED_COUNT
#define RGBLIGHT_LED_COUNT 24
#define RGBLED_SPLIT { 12, 12 }
#define RGBLIGHT_EFFECT_BREATHING
#define RGBLIGHT_EFFECT_RAINBOW_MOOD
#define RGBLIGHT_EFFECT_RAINBOW_SWIRL
#define RGBLIGHT_EFFECT_SNAKE
#define RGBLIGHT_EFFECT_KNIGHT
#define RGBLIGHT_EFFECT_CHRISTMAS
#define RGBLIGHT_EFFECT_STATIC_GRADIENT
#define RGBLIGHT_EFFECT_RGB_TEST
#define RGBLIGHT_EFFECT_ALTERNATING
