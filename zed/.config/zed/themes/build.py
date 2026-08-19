#!/usr/bin/env python3
"""Build themes/Grey.json from a single palette + role table.

    python3 themes/build.py

A Zed theme is ~140 flat colour keys, so the hand-written version drifts: dead
keys that Zed silently ignores, and the same colour pasted in 20 places. Here
the palette is declared once and every UI slot names a *role* rather than a hex
value. Output is validated against the vendored Zed schema, so a typo'd key
fails the build instead of being dropped at load time.

Light only. The original "Minimal" family also carried a dark appearance; it
was dropped deliberately. To add one back, define a second palette with the
same role keys and append another build_variant() call.

Palette follows https://github.com/yorickpeterse/nvim-grey, matching
~/.config/nvim/lua/palette/grey.lua.
"""

import json
import pathlib
import sys

HERE = pathlib.Path(__file__).parent
SCHEMA = HERE / "zed-theme-schema.json"
OUT = HERE / "Grey.json"

THEME_NAME = "Grey"
AUTHOR = "tdfirth"  # original "Minimal" theme, reworked

# --------------------------------------------------------------------------
# Palette
#
# Roles, not colour names, are what the UI/syntax tables below reference, so
# those tables stay independent of any one palette.
# --------------------------------------------------------------------------

LIGHT = {
    "appearance": "light",
    # surfaces
    "bg": "#FCFCFC",  # editor / main background
    "bg_surface": "#F9F9F9",  # panels, popovers
    "bg_element": "#F0F0F0",  # buttons, hovered rows
    "bg_active_line": "#F0F0F0",
    "bg_selection": "#D3E0F2",  # grey.lua light_blue -- must read at a glance
    # Same colour as bg_selection once composited over bg, but kept as blue at
    # 18% alpha. Markdown preview paints element.selection_background ON TOP of
    # the text rather than behind it, so an opaque value there hides every
    # selected glyph. Alpha is load-bearing: do not flatten this to a solid.
    "bg_selection_overlay": "#1561B82E",
    "bg_search": "#F9EAB3",  # grey.lua light_yellow
    "bg_highlight": "#E6E6E6",  # LSP document highlight
    "bg_bracket": "#E3EAF3",  # grey.lua highlight
    "bg_code": "#ECECEC",  # grey.lua grey_bg_light; preview's own chip is #E8E8E8
    "bg_blend": "#FCFCFC",  # base for deriving dim terminal colours
    # ink
    "fg": "#000000DF",
    "fg_muted": "#5E5E5E",  # grey.lua grey
    "fg_subtle": "#9A9A9A",  # placeholders, ignored files
    "fg_faint": "#B4B4B4",  # inactive line numbers
    # lines
    "border": "#CCCCCC",
    "guide": "#E6E6E6",
    "guide_active": "#CCCCCC",
    # accents
    "blue": "#1561B8",
    "green": "#1C5708",
    "red": "#C4331D",
    "orange": "#A55000",
    "yellow": "#B37F02",  # grey.lua dark_yellow
    "purple": "#5C21A5",
    "cyan": "#007872",
    # terminal (normal / bright); dim is derived by blending toward bg_blend
    "ansi": {
        "black": "#000000",
        "red": "#C4331D",
        "green": "#1C5708",
        "yellow": "#B37F02",
        "blue": "#1561B8",
        "magenta": "#5C21A5",
        "cyan": "#007872",
        "white": "#CCCCCC",
    },
    "ansi_bright": {
        "black": "#5E5E5E",
        "red": "#E04A30",
        "green": "#2E7A18",
        "yellow": "#D19A0F",
        "blue": "#2077D6",
        "magenta": "#7B3BC7",
        "cyan": "#009B93",
        "white": "#EDEDED",
    },
}

def blend(fg: str, bg: str, ratio: float) -> str:
    """Mix `fg` toward `bg`. ratio=0 keeps fg, ratio=1 returns bg."""
    f, b = fg.lstrip("#")[:6], bg.lstrip("#")[:6]
    mixed = (
        round(int(f[i : i + 2], 16) * (1 - ratio) + int(b[i : i + 2], 16) * ratio)
        for i in (0, 2, 4)
    )
    return "#" + "".join(f"{c:02X}" for c in mixed)


# --------------------------------------------------------------------------
# UI
# --------------------------------------------------------------------------


def ui_colors(p: dict) -> dict:
    """Every non-syntax key, expressed in roles."""
    keys = {
        "background.appearance": "opaque",
        # borders
        "border": p["border"],
        "border.variant": p["border"],
        "border.focused": p["blue"],
        "border.selected": p["border"],
        "border.transparent": "#00000000",
        "border.disabled": p["border"],
        # surfaces
        "background": p["bg"],
        "surface.background": p["bg_surface"],
        "elevated_surface.background": p["bg_surface"],
        "panel.background": p["bg_surface"],
        "status_bar.background": p["bg"],
        "title_bar.background": p["bg"],
        "title_bar.inactive_background": p["bg"],
        "toolbar.background": p["bg"],
        "tab_bar.background": p["bg"],
        "tab.inactive_background": p["bg"],
        "tab.active_background": p["bg"],
        "pane_group.border": p["border"],
        # interactive elements
        "element.background": p["bg_element"],
        "element.hover": p["bg_element"],
        "element.selected": p["bg_element"],
        # Markdown preview and other UI text selections read this key, NOT
        # players[0].selection. Zed's built-in default is a hardcoded
        # blue-at-25%-alpha, which is why preview selection looked nothing like
        # the editor's. Pinning it to the same colour keeps the two identical.
        "element.selection_background": p["bg_selection_overlay"],
        "ghost_element.hover": p["bg_element"],
        "ghost_element.selected": p["bg_element"],
        "drop_target.background": p["bg_selection"],
        # text
        "text": p["fg"],
        "text.muted": p["fg_muted"],
        "text.placeholder": p["fg_subtle"],
        "text.disabled": p["fg_subtle"],
        "text.accent": p["blue"],
        "icon": p["fg"],
        "icon.muted": p["fg_muted"],
        "icon.disabled": p["fg_subtle"],
        "icon.placeholder": p["fg_subtle"],
        "icon.accent": p["blue"],
        # editor
        "editor.foreground": p["fg"],
        "editor.background": p["bg"],
        "editor.gutter.background": p["bg"],
        "editor.active_line.background": p["bg_active_line"],
        "editor.line_number": p["fg_faint"],
        "editor.active_line_number": p["fg"],
        "editor.wrap_guide": p["guide"],
        "editor.active_wrap_guide": p["guide_active"],
        "editor.indent_guide": p["guide"],
        "editor.indent_guide_active": p["guide_active"],
        "editor.invisible": p["fg_subtle"],
        "editor.document_highlight.read_background": p["bg_highlight"],
        "editor.document_highlight.write_background": p["bg_highlight"],
        "editor.document_highlight.bracket_background": p["bg_bracket"],
        "search.match_background": p["bg_search"],
        "panel.indent_guide": p["guide"],
        "panel.indent_guide_active": p["guide_active"],
        "panel.indent_guide_hover": p["guide_active"],
        # scrollbar
        "scrollbar.thumb.background": blend(p["fg_subtle"], p["bg_blend"], 0.5),
        "scrollbar.thumb.hover_background": p["fg_subtle"],
        "scrollbar.thumb.border": blend(p["fg_subtle"], p["bg_blend"], 0.5),
        "scrollbar.track.background": p["bg"],
        "scrollbar.track.border": p["bg"],
        # status colours
        "link_text.hover": p["blue"],
        "conflict": p["orange"],
        "created": p["green"],
        "deleted": p["red"],
        "error": p["red"],
        "warning": p["yellow"],
        "info": p["blue"],
        "success": p["green"],
        "modified": p["blue"],
        "renamed": p["purple"],
        "hint": p["fg_muted"],
        "hidden": p["fg_subtle"],
        "ignored": p["fg_subtle"],
        "predictive": p["fg_subtle"],
        "unreachable": p["fg_subtle"],
        # cursor + selection. Zed reads these from `players` only -- the
        # `editor.selection` / `selection.background` / `cursor` keys some
        # themes carry are not in the schema and are ignored on load.
        "players": [
            {
                "cursor": p["fg"],
                "selection": p["bg_selection"],
                "background": p["blue"],
            }
        ],
    }

    # Status colours also get subtle background/border tints, e.g. for
    # diagnostics gutters and the git panel.
    for name in ("conflict", "created", "deleted", "error", "warning", "info",
                 "success", "modified", "renamed", "hint", "hidden", "ignored",
                 "predictive", "unreachable"):
        keys[f"{name}.background"] = blend(keys[name], p["bg_blend"], 0.85)
        keys[f"{name}.border"] = blend(keys[name], p["bg_blend"], 0.6)

    # Terminal.
    keys["terminal.background"] = p["bg"]
    keys["terminal.ansi.background"] = p["bg"]
    keys["terminal.foreground"] = p["fg"]
    keys["terminal.bright_foreground"] = p["ansi_bright"]["white"]
    keys["terminal.dim_foreground"] = p["fg_muted"]
    for name, color in p["ansi"].items():
        keys[f"terminal.ansi.{name}"] = color
        keys[f"terminal.ansi.bright_{name}"] = p["ansi_bright"][name]
        keys[f"terminal.ansi.dim_{name}"] = blend(color, p["bg_blend"], 0.4)

    keys["accents"] = [p[c] for c in ("blue", "green", "orange", "purple", "cyan", "red")]
    return keys


# --------------------------------------------------------------------------
# Syntax
#
# (token, role, font_weight, font_style).
# Weights carry over from the original theme: structure is signalled by weight,
# colour is reserved for the few things that genuinely need to stand apart.
# --------------------------------------------------------------------------

SYNTAX = [
    ("comment",                 "fg_muted", None, None),
    ("comment.doc",             "fg_muted", None, None),
    ("constant",                "fg",       800,  None),
    ("constructor",             "fg",       None, None),
    ("emphasis",                "fg",       None, "italic"),
    ("emphasis.strong",         "fg",       700,  None),
    ("function",                "fg",       700,  None),
    ("keyword",                 "fg",       None, None),
    ("label",                   "fg",       None, None),
    ("tag",                     "fg",       None, None),
    ("type",                    "fg",       700,  None),
    ("variable",                "fg",       None, None),
    ("variable.special",        "fg",       800,  None),
    ("punctuation.bracket",     "fg",       None, None),
    ("punctuation.list_marker", "fg",       700,  None),
    ("operator",                "fg",       800,  None),
    ("boolean",                 "fg",       800,  None),
    ("preproc",                 "fg",       800,  None),
    ("title",                   "fg",       700,  None),
    # the readable-at-a-glance set
    ("link_text",               "blue",     None, None),
    ("link_uri",                "blue",     None, None),
    ("number",                  "blue",     None, None),
    ("string",                  "green",    None, None),
    ("string.doc",              "green",    None, None),
    ("string.special",          "green",    None, None),
    ("string.special.symbol",   "green",    None, None),
    ("string.escape",           "orange",   None, None),
    ("string.regex",            "orange",   None, None),
    ("text.literal",            "fg_muted", None, None),
    # Markdown inline `code`. Zed captures code_span as text.literal.markup,
    # while fenced blocks go to the injected language -- so this hits inline
    # spans only. Regular ink; the chip alone marks it, so nothing competes
    # with **bold** on either colour or weight.
    ("text.literal.markup",     "fg",       None, None),
]


# Tokens that also get a background tint, keyed by palette role.
SYNTAX_BACKGROUNDS = {"text.literal.markup": "bg_code"}


def syntax_colors(p: dict) -> dict:
    out = {}
    for token, role, weight, style in SYNTAX:
        entry = {"color": p[role]}
        if token in SYNTAX_BACKGROUNDS:
            entry["background_color"] = p[SYNTAX_BACKGROUNDS[token]]
        if weight is not None:
            entry["font_weight"] = weight
        if style is not None:
            entry["font_style"] = style
        out[token] = entry
    return out


# --------------------------------------------------------------------------


def build_variant(p: dict, name: str) -> dict:
    style = ui_colors(p)
    style["syntax"] = syntax_colors(p)
    return {"name": name, "appearance": p["appearance"], "style": style}


# Keys the running Zed accepts that the published v0.2.0 schema predates.
# v0.2.0 is the newest schema zed.dev serves (v0.3.0 is a 404) and the shipped
# One theme still targets it, so the schema lags the binary. Verify before
# adding to this list:
#   strings -a /Applications/Zed.app/Contents/MacOS/zed | grep <key>
# and cross-check crates/settings_content/src/theme.rs upstream.
SCHEMA_LAG_KEYS = {
    "element.selection_background",  # verified present in Zed 1.15.1
}


def validate(family: dict) -> list[str]:
    """Reject keys Zed's schema does not define -- they load as no-ops."""
    if not SCHEMA.exists():
        print(f"warning: {SCHEMA.name} missing, skipping validation", file=sys.stderr)
        return []
    schema = json.loads(SCHEMA.read_text())
    allowed = set(schema["definitions"]["ThemeStyleContent"]["properties"]) | SCHEMA_LAG_KEYS
    weights = set(schema["definitions"]["HighlightStyleContent"]["properties"]
                  ["font_weight"]["anyOf"][0]["enum"])
    errors = []
    for theme in family["themes"]:
        for key in theme["style"]:
            if key != "syntax" and key not in allowed:
                errors.append(f"{theme['name']}: unknown style key {key!r}")
        for token, entry in theme["style"]["syntax"].items():
            if "font_weight" in entry and entry["font_weight"] not in weights:
                errors.append(f"{theme['name']}: bad font_weight on {token!r}")
    return errors


def main() -> int:
    family = {
        "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
        "name": THEME_NAME,
        "author": AUTHOR,
        "themes": [build_variant(LIGHT, THEME_NAME)],
    }

    errors = validate(family)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    OUT.write_text(json.dumps(family, indent=2) + "\n")
    keys = len(family["themes"][0]["style"])
    names = ", ".join(t["name"] for t in family["themes"])
    print(f"wrote {OUT.relative_to(HERE.parent)}: {names} ({keys} keys)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
