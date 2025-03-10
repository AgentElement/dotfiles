#!/bin/sh

# Set XDG_SESSION_DESKTOP to convince logind that the current session
# is not a tty.
# See documentation: https://man.sr.ht/~kennylevinsen/greetd/

# Session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland

# Wayland stuff
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

exec Hyprland "$@"
