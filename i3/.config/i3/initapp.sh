#!/bin/bash
set -e;
if ! pgrep ghostty >/dev/null; then echo "Launching ghostty..." && swaymsg "exec /usr/bin/ghostty"; fi
if ! pgrep librewolf >/dev/null; then echo "Launching librewolf..." && swaymsg "exec /usr/bin/librewolf"; fi
