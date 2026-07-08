#!/bin/sh
# Open sunbeam in a right split from the active herdr pane, then close the
# split when sunbeam exits. Mirrors the zellij "Alt ." floating launcher, but
# herdr has no floating panes so this uses a tiled right split instead.
#
# Wired from config/herdr/config.toml as a custom command keybinding:
#   [[keys.command]]
#   key = "alt+."
#   type = "shell"
#   command = "~/.config/herdr/herdr-sunbeam-split.sh"
#
# herdr passes HERDR_BIN_PATH and HERDR_ACTIVE_PANE_ID to custom commands.

set -eu

herdr="${HERDR_BIN_PATH:-herdr}"

# Resolve the source pane: prefer the env herdr injects, fall back to querying.
src_pane="${HERDR_ACTIVE_PANE_ID:-}"
if [ -z "$src_pane" ]; then
  src_pane=$("$herdr" pane current 2>/dev/null \
    | sed -n 's/.*"pane_id":"\([^"]*\)".*/\1/p' | head -n1)
fi
[ -n "$src_pane" ] || { echo "herdr-sunbeam-split: no source pane" >&2; exit 1; }

# Split right so the sunbeam pane takes one third of the window width.
# --ratio sizes the ORIGINAL pane, so 0.67 leaves ~1/3 for the new pane.
new_pane=$("$herdr" pane split "$src_pane" --direction right --ratio 0.67 --focus 2>/dev/null \
  | sed -n 's/.*"pane_id":"\([^"]*\)".*/\1/p' | head -n1)
[ -n "$new_pane" ] || { echo "herdr-sunbeam-split: split failed" >&2; exit 1; }

# Run sunbeam in the new pane; close the pane when sunbeam exits.
"$herdr" pane run "$new_pane" "sunbeam; \"$herdr\" pane close $new_pane"
