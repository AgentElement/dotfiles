#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar_top-main.log /tmp/polybar_top-secondary.log /tmp/polybar_top-workspaces.log
# if [[ -n "$(xrandr --query | grep "^DP-1 connected")$" ]]; then
# echo "External monitor on displayport found"
# polybar --config=$HOME/.config/polybar/config.ini top-secondary 2>&1 | tee -a /tmp/polybar_top-secondary.log & disown
# fi

for m in $(polybar --list-monitors | cut -d":" -f1); do

    MONITOR=$m polybar --config=$HOME/.config/polybar/config.ini top-workspaces 2>&1 | tee -a /tmp/polybar_top-workspaces.log  & disown

    if [[ $m = "eDP-1" ]]; then
        MONITOR=$m polybar --config=$HOME/.config/polybar/config.ini top-main 2>&1 | tee -a /tmp/polybar_top-main.log & disown
    else
        MONITOR=$m polybar --config=$HOME/.config/polybar/config.ini top-secondary 2>&1 | tee -a /tmp/polybar_top-secondary.log & disown
    fi
done

echo "Bars launched..."
