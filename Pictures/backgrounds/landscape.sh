#!/bin/bash

# Forever cycle through a random order of vacation photos in 30 minute intervals
# landscape photos for the landscape screen
while true; do
    ls $HOME/Pictures/backgrounds/landscape | sort -R  | while read file; do
        swww img "$HOME/Pictures/backgrounds/landscape/$file" --outputs "HDMI-A-1,eDP-1,DP-3,DP-5"  --transition-type wipe
        sleep 30m
    done
done
