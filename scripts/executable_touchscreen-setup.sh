#!/bin/bash

xinput --map-to-output "Wacom HID 516B Finger touch" eDP-1
xinput --map-to-output "Wacom HID 516B Pen stylus" eDP-1
xinput --map-to-output "Wacom HID 516B Pen eraser" eDP-1
xsetwacom --set "Wacom HID 516B Finger touch" Gesture off

if [ -x "$(command -v unclutter)" ]; then
    unclutter --timeout 600 -b --hide-on-touch
else
    # https://github.com/Airblader/unclutter-xfixes
    echo 'unclutter-xfixes not installed. Cursor will not auto-hide when touchscreen is touched.' >&2
fi
